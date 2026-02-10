defmodule AiAgentProjectAssessor.CLI do
  @moduledoc """
  Command-line interface utilities for the AI Agent Project Assessor.

  Provides common functionality for Mix tasks including:
  - Colored output formatting
  - User input handling
  - Progress display
  - Streaming response rendering

  ## Usage

  This module is used internally by Mix tasks like:
  - `mix ai.assess.new` - Start a new assessment
  - `mix ai.assess.resume` - Resume an existing assessment
  - `mix ai.assess.list` - List all assessments
  """

  @colors %{
    info: :cyan,
    success: :green,
    warning: :yellow,
    error: :red,
    ai: :blue,
    user: :white,
    dim: :light_black
  }

  # ============================================================================
  # Output Functions
  # ============================================================================

  @doc """
  Prints a header banner for the CLI.
  """
  def print_header do
    IO.puts("")
    print_colored("========================================", :dim)
    print_colored("    AI Agent Project Assessor CLI", :info)
    print_colored("========================================", :dim)
    IO.puts("")
  end

  @doc """
  Prints colored text to the console.
  """
  def print_colored(text, color) when is_atom(color) do
    color_code = Map.get(@colors, color, color)
    IO.puts(IO.ANSI.format([color_code, text]))
  end

  @doc """
  Prints an info message.
  """
  def info(message) do
    print_colored("[INFO] #{message}", :info)
  end

  @doc """
  Prints a success message.
  """
  def success(message) do
    print_colored("[OK] #{message}", :success)
  end

  @doc """
  Prints a warning message.
  """
  def warn(message) do
    print_colored("[WARN] #{message}", :warning)
  end

  @doc """
  Prints an error message.
  """
  def error(message) do
    print_colored("[ERROR] #{message}", :error)
  end

  @doc """
  Prints AI response text with appropriate formatting.
  """
  def print_ai(text) do
    IO.puts("")
    print_colored("AI:", :ai)
    IO.puts(text)
    IO.puts("")
  end

  @doc """
  Prints a divider line.
  """
  def divider do
    print_colored("----------------------------------------", :dim)
  end

  # ============================================================================
  # Input Functions
  # ============================================================================

  @doc """
  Prompts the user for input with a given prompt string.
  Returns the trimmed input.
  """
  def prompt(prompt_text) do
    IO.write(IO.ANSI.format([:white, prompt_text]))

    case IO.gets("") do
      :eof -> nil
      {:error, _} -> nil
      input -> String.trim(input)
    end
  end

  @doc """
  Prompts for multiline input until a blank line is entered.
  """
  def prompt_multiline(prompt_text) do
    IO.puts(prompt_text)
    print_colored("(Enter a blank line when done)", :dim)
    IO.puts("")

    collect_multiline([])
    |> Enum.reverse()
    |> Enum.join("\n")
    |> String.trim()
  end

  defp collect_multiline(lines) do
    case IO.gets("") do
      :eof ->
        lines

      {:error, _} ->
        lines

      input ->
        line = String.trim_trailing(input, "\n")

        if line == "" do
          lines
        else
          collect_multiline([line | lines])
        end
    end
  end

  @doc """
  Prompts for yes/no confirmation.
  """
  def confirm?(prompt_text) do
    response = prompt("#{prompt_text} [y/N]: ")
    String.downcase(response) in ["y", "yes"]
  end

  # ============================================================================
  # Progress Display
  # ============================================================================

  @doc """
  Displays assessment progress status.
  """
  def print_status(session) do
    divider()
    print_colored("Assessment Status", :info)
    divider()

    IO.puts("  Session: #{session.name}")
    IO.puts("  Status:  #{format_status(session.status)}")
    IO.puts("  Confidence: #{format_percentage(session.confidence)}")
    IO.puts("  Dimensions: #{session.dimensions_complete}/12 complete")

    divider()
  end

  @doc """
  Displays a progress bar for confidence level.
  """
  def print_progress_bar(confidence) do
    filled = round(confidence * 20)
    empty = 20 - filled

    bar =
      IO.ANSI.format([
        :green,
        String.duplicate("=", filled),
        :light_black,
        String.duplicate("-", empty)
      ])

    IO.puts("[#{bar}] #{format_percentage(confidence)}")
  end

  @doc """
  Displays dimension completion status.
  """
  def print_dimensions(dimensions_data) do
    dimensions = [
      "Problem Statement",
      "Solution Approach",
      "Data Availability",
      "Data Quality",
      "Technical Feasibility",
      "Integration Requirements",
      "Success Criteria",
      "User Requirements",
      "Constraints",
      "Risk Factors",
      "Timeline",
      "Budget"
    ]

    IO.puts("")
    print_colored("Dimension Progress:", :info)

    Enum.each(Enum.with_index(dimensions), fn {dim, _idx} ->
      confidence = get_in(dimensions_data, [dim]) || 0.0
      status = if confidence >= 0.95, do: "[X]", else: "[ ]"
      conf_str = format_percentage(confidence)

      color = if confidence >= 0.95, do: :green, else: :yellow
      IO.puts(IO.ANSI.format([color, "  #{status} #{dim}: #{conf_str}"]))
    end)

    IO.puts("")
  end

  # ============================================================================
  # Streaming Output
  # ============================================================================

  @doc """
  Renders streaming text chunks as they arrive.
  """
  def stream_text(chunk) do
    IO.write(chunk)
  end

  @doc """
  Marks the end of a streaming response.
  """
  def end_stream do
    IO.puts("")
    IO.puts("")
  end

  # ============================================================================
  # Command Parsing
  # ============================================================================

  @doc """
  Parses slash commands from user input.

  Returns `{:command, command, args}` for commands or `{:text, text}` for regular input.
  """
  def parse_input(input) do
    input = String.trim(input)

    if String.starts_with?(input, "/") do
      [command | args] = String.split(input, " ", parts: 2)
      command = String.trim_leading(command, "/")
      args = if args == [], do: "", else: hd(args)
      {:command, command, args}
    else
      {:text, input}
    end
  end

  @doc """
  Prints available commands.
  """
  def print_help do
    IO.puts("")
    print_colored("Available Commands:", :info)
    IO.puts("  /status    - Show assessment progress")
    IO.puts("  /save      - Save current session")
    IO.puts("  /report    - Generate report (when ready)")
    IO.puts("  /export    - Export report to PDF/Word/Markdown")
    IO.puts("  /quit      - Exit the session")
    IO.puts("  /help      - Show this help message")
    IO.puts("")
    IO.puts("Just type normally to answer questions or provide information.")
    IO.puts("")
  end

  # ============================================================================
  # Formatting Helpers
  # ============================================================================

  defp format_status(status) do
    case status do
      :gathering -> "Gathering Information"
      :ready_for_report -> "Ready for Report Generation"
      :report_generated -> "Report Generated"
      :editing -> "Editing"
      :exported -> "Exported"
      _ -> to_string(status)
    end
  end

  defp format_percentage(value) when is_float(value) do
    "#{round(value * 100)}%"
  end

  defp format_percentage(_), do: "0%"
end
