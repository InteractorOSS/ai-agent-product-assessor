defmodule AiAgentProjectAssessor.Workers.ExportWorker do
  @moduledoc """
  Oban worker for generating report exports.

  Handles asynchronous export generation for PDF, DOCX, Markdown, and HTML formats.
  Uses Pandoc for document conversion with pure-Elixir fallback for HTML/PDF.

  ## Usage

      %{report_id: report_id, format: "pdf", user_id: user_id}
      |> ExportWorker.new()
      |> Oban.insert()

  """

  use Oban.Worker,
    queue: :exports,
    max_attempts: 3,
    priority: 1

  require Logger

  alias AiAgentProjectAssessor.Reports
  alias AiAgentProjectAssessor.Reports.Report
  alias AiAgentProjectAssessor.Notifications

  @export_dir "priv/exports"

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"report_id" => report_id, "format" => format} = args}) do
    user_id = Map.get(args, "user_id")
    Logger.info("Starting export generation", report_id: report_id, format: format)

    with {:ok, report} <- fetch_report(report_id),
         {:ok, file_path} <- generate_export(report, format),
         {:ok, export} <- record_export(report, format, file_path, user_id) do
      Logger.info("Export completed", export_id: export.id, file_path: file_path)

      # Send notification if user_id is provided
      if user_id do
        notify_export_complete(report, export, user_id)
      end

      # Broadcast via PubSub for LiveView updates
      broadcast_export_complete(report_id, export)

      {:ok, export.id}
    else
      {:error, :not_found} ->
        Logger.error("Report not found", report_id: report_id)
        if user_id, do: notify_export_failed(report_id, "Report not found", user_id)
        {:error, :report_not_found}

      {:error, reason} ->
        Logger.error("Export failed", report_id: report_id, reason: inspect(reason))
        if user_id, do: notify_export_failed(report_id, inspect(reason), user_id)
        {:error, reason}
    end
  end

  @doc """
  Creates a new export job for the given report and format.

  ## Options

    * `:user_id` - Optional user ID for sending notifications

  ## Examples

      iex> ExportWorker.enqueue(report_id, :pdf)
      {:ok, %Oban.Job{}}

      iex> ExportWorker.enqueue(report_id, :pdf, user_id: user_id)
      {:ok, %Oban.Job{}}

  """
  @spec enqueue(String.t(), atom(), keyword()) ::
          {:ok, Oban.Job.t()} | {:error, Oban.Job.changeset()}
  def enqueue(report_id, format, opts \\ []) when format in [:pdf, :docx, :markdown, :html] do
    args = %{report_id: report_id, format: to_string(format)}

    args =
      case Keyword.get(opts, :user_id) do
        nil -> args
        user_id -> Map.put(args, :user_id, user_id)
      end

    args
    |> new()
    |> Oban.insert()
  end

  # Private functions

  defp fetch_report(report_id) do
    case Reports.get_report_with_preloads!(report_id) do
      nil -> {:error, :not_found}
      report -> {:ok, report}
    end
  rescue
    Ecto.NoResultsError -> {:error, :not_found}
  end

  defp generate_export(%Report{} = report, format) do
    ensure_export_dir()

    timestamp = DateTime.utc_now() |> DateTime.to_unix()
    filename = "report_#{report.id}_#{timestamp}.#{format}"
    file_path = Path.join(@export_dir, filename)

    # Generate markdown source from report content
    markdown_content = render_report_markdown(report)
    markdown_path = Path.join(@export_dir, "report_#{report.id}_#{timestamp}.md")

    File.write!(markdown_path, markdown_content)

    case format do
      "markdown" ->
        # For markdown, just rename the file
        File.rename!(markdown_path, file_path)
        {:ok, file_path}

      "html" ->
        convert_with_pandoc(markdown_path, file_path, "html")

      "pdf" ->
        convert_with_pandoc(markdown_path, file_path, "pdf")

      "docx" ->
        convert_with_pandoc(markdown_path, file_path, "docx")

      _ ->
        {:error, :unsupported_format}
    end
  end

  defp convert_with_pandoc(source_path, output_path, format) do
    if pandoc_available?() do
      pandoc_args = build_pandoc_args(source_path, output_path, format)

      case System.cmd("pandoc", pandoc_args, stderr_to_stdout: true) do
        {_output, 0} ->
          # Clean up source markdown if different from output
          if source_path != output_path, do: File.rm(source_path)
          {:ok, output_path}

        {error_output, exit_code} ->
          Logger.warning("Pandoc conversion failed, trying fallback",
            exit_code: exit_code,
            output: error_output,
            format: format
          )

          # Try fallback for supported formats
          fallback_convert(source_path, output_path, format)
      end
    else
      Logger.info("Pandoc not available, using fallback converter", format: format)
      fallback_convert(source_path, output_path, format)
    end
  end

  defp pandoc_available? do
    case System.cmd("which", ["pandoc"], stderr_to_stdout: true) do
      {_, 0} -> true
      _ -> false
    end
  rescue
    _ -> false
  end

  defp fallback_convert(source_path, output_path, "html") do
    markdown_content = File.read!(source_path)
    html_content = render_html_fallback(markdown_content)
    File.write!(output_path, html_content)
    File.rm(source_path)
    {:ok, output_path}
  end

  defp fallback_convert(source_path, output_path, "pdf") do
    # For PDF, generate HTML first then note that it's HTML-based
    markdown_content = File.read!(source_path)
    html_content = render_html_fallback(markdown_content, print_styles: true)

    # Save as HTML with .pdf extension note for download handling
    html_output = String.replace(output_path, ".pdf", "_printable.html")
    File.write!(html_output, html_content)
    File.rm(source_path)

    Logger.info("PDF fallback: Generated printable HTML instead", path: html_output)
    {:ok, html_output}
  end

  defp fallback_convert(_source_path, _output_path, format) do
    {:error, {:no_fallback_for_format, format}}
  end

  defp render_html_fallback(markdown_content, opts \\ []) do
    print_styles = Keyword.get(opts, :print_styles, false)

    # Simple markdown to HTML conversion
    html_body = markdown_to_html(markdown_content)

    print_css =
      if print_styles do
        """
        @media print {
          body { font-size: 12pt; }
          .page-break { page-break-before: always; }
        }
        @page { margin: 2.5cm; }
        """
      else
        ""
      end

    """
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>AI Assessment Report</title>
      <style>
        * { box-sizing: border-box; }
        body {
          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
          line-height: 1.6;
          max-width: 800px;
          margin: 0 auto;
          padding: 2rem;
          color: #1a1a1a;
          background: #ffffff;
        }
        h1 { color: #111827; border-bottom: 2px solid #4CD964; padding-bottom: 0.5rem; }
        h2 { color: #374151; margin-top: 2rem; }
        h3 { color: #4b5563; }
        p { margin: 1rem 0; }
        ul, ol { margin: 1rem 0; padding-left: 2rem; }
        li { margin: 0.5rem 0; }
        blockquote {
          border-left: 4px solid #4CD964;
          padding-left: 1rem;
          margin: 1rem 0;
          color: #4b5563;
          background: #f9fafb;
          padding: 1rem;
        }
        code {
          background: #f3f4f6;
          padding: 0.2rem 0.4rem;
          border-radius: 4px;
          font-family: 'Monaco', 'Menlo', monospace;
          font-size: 0.9em;
        }
        pre {
          background: #1f2937;
          color: #e5e7eb;
          padding: 1rem;
          border-radius: 8px;
          overflow-x: auto;
        }
        pre code { background: transparent; color: inherit; }
        table { border-collapse: collapse; width: 100%; margin: 1rem 0; }
        th, td { border: 1px solid #d1d5db; padding: 0.75rem; text-align: left; }
        th { background: #f3f4f6; }
        hr { border: none; border-top: 1px solid #e5e7eb; margin: 2rem 0; }
        .footer { color: #6b7280; font-size: 0.875rem; margin-top: 3rem; text-align: center; }
        #{print_css}
      </style>
    </head>
    <body>
      #{html_body}
      <div class="footer">
        <p>Generated by AI Agent Project Assessor</p>
      </div>
    </body>
    </html>
    """
  end

  defp markdown_to_html(markdown) do
    markdown
    |> String.split("\n")
    |> Enum.map(&process_markdown_line/1)
    |> Enum.join("\n")
    |> wrap_paragraphs()
  end

  defp process_markdown_line("# " <> text), do: "<h1>#{escape_html(text)}</h1>"
  defp process_markdown_line("## " <> text), do: "<h2>#{escape_html(text)}</h2>"
  defp process_markdown_line("### " <> text), do: "<h3>#{escape_html(text)}</h3>"
  defp process_markdown_line("---"), do: "<hr>"
  defp process_markdown_line("- " <> text), do: "<li>#{escape_html(text)}</li>"
  defp process_markdown_line("* " <> text), do: "<li>#{escape_html(text)}</li>"
  defp process_markdown_line("> " <> text), do: "<blockquote>#{escape_html(text)}</blockquote>"
  defp process_markdown_line(""), do: "</p><p>"
  defp process_markdown_line(text), do: process_inline_formatting(text)

  defp process_inline_formatting(text) do
    text
    |> escape_html()
    |> String.replace(~r/\*\*(.+?)\*\*/, "<strong>\\1</strong>")
    |> String.replace(~r/\*(.+?)\*/, "<em>\\1</em>")
    |> String.replace(~r/`(.+?)`/, "<code>\\1</code>")
  end

  defp escape_html(text) do
    text
    |> String.replace("&", "&amp;")
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
    |> String.replace("\"", "&quot;")
  end

  defp wrap_paragraphs(html) do
    # Wrap text content in paragraphs and handle list items
    html
    |> String.replace(~r/<\/li>\n<li>/, "</li>\n<li>")
    |> String.replace(~r/(<li>.*<\/li>)+/s, fn match -> "<ul>#{match}</ul>" end)
    |> then(fn content -> "<p>#{content}</p>" end)
    |> String.replace("<p></p>", "")
    |> String.replace("<p><h", "<h")
    |> String.replace("</h1></p>", "</h1>")
    |> String.replace("</h2></p>", "</h2>")
    |> String.replace("</h3></p>", "</h3>")
    |> String.replace("<p><hr></p>", "<hr>")
    |> String.replace("<p><ul>", "<ul>")
    |> String.replace("</ul></p>", "</ul>")
    |> String.replace("<p><blockquote>", "<blockquote>")
    |> String.replace("</blockquote></p>", "</blockquote>")
  end

  defp build_pandoc_args(source_path, output_path, format) do
    base_args = [source_path, "-o", output_path]

    format_args =
      case format do
        "pdf" -> ["--pdf-engine=weasyprint", "--metadata", "title=AI Assessment Report"]
        "docx" -> ["--reference-doc=priv/templates/reference.docx"]
        "html" -> ["--standalone", "--metadata", "title=AI Assessment Report"]
        _ -> []
      end

    base_args ++ format_args
  end

  defp render_report_markdown(%Report{content: content, section_order: section_order}) do
    sections =
      section_order
      |> Enum.map(fn section_key ->
        section_content = Map.get(content, section_key, "")
        section_title = humanize_section(section_key)

        """
        ## #{section_title}

        #{section_content}
        """
      end)
      |> Enum.join("\n\n")

    """
    # AI Agent Project Assessment Report

    #{sections}

    ---
    *Generated by AI Agent Project Assessor*
    """
  end

  defp humanize_section(key) do
    key
    |> String.replace("_", " ")
    |> String.split()
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  defp record_export(%Report{id: report_id}, format, file_path, user_id) do
    file_size =
      case File.stat(file_path) do
        {:ok, %{size: size}} -> size
        _ -> 0
      end

    attrs = %{
      report_id: report_id,
      format: String.to_existing_atom(format),
      file_path: file_path,
      file_size: file_size
    }

    attrs = if user_id, do: Map.put(attrs, :generated_by, user_id), else: attrs

    Reports.create_export(attrs)
  end

  defp ensure_export_dir do
    File.mkdir_p!(@export_dir)
  end

  # Notification helpers

  defp notify_export_complete(report, export, user_id) do
    Notifications.send_export_ready(user_id, %{
      report_id: report.id,
      export_id: export.id,
      format: export.format,
      file_path: export.file_path
    })
  rescue
    error ->
      Logger.warning("Failed to send export notification",
        error: inspect(error),
        user_id: user_id
      )
  end

  defp notify_export_failed(report_id, reason, user_id) do
    Notifications.send_export_failed(user_id, %{
      report_id: report_id,
      reason: reason
    })
  rescue
    error ->
      Logger.warning("Failed to send export failure notification",
        error: inspect(error),
        user_id: user_id
      )
  end

  defp broadcast_export_complete(report_id, export) do
    Phoenix.PubSub.broadcast(
      AiAgentProjectAssessor.PubSub,
      "report:#{report_id}",
      {:export_complete, export}
    )
  end
end
