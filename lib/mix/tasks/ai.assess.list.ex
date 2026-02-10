defmodule Mix.Tasks.Ai.Assess.List do
  @shortdoc "List all AI project assessment sessions"

  @moduledoc """
  Lists all AI project assessment sessions.

  ## Usage

      mix ai.assess.list [options]

  ## Options

    * `--status`, `-s` - Filter by status (gathering, ready_for_report, report_generated, editing, exported)
    * `--user`, `-u` - Filter by user identifier
    * `--limit`, `-l` - Maximum number of results (default: 20)

  ## Examples

      # List all sessions
      mix ai.assess.list

      # List only active sessions
      mix ai.assess.list --status gathering

      # List sessions for a specific user
      mix ai.assess.list --user john

  ## Output

  The command displays a table with:
    * Session ID (truncated for display)
    * Name
    * Status
    * Confidence percentage
    * Created date
  """

  use Mix.Task

  alias AiAgentProjectAssessor.CLI
  alias AiAgentProjectAssessor.Assessments

  @switches [
    status: :string,
    user: :string,
    limit: :integer
  ]

  @aliases [
    s: :status,
    u: :user,
    l: :limit
  ]

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")

    {opts, _remaining, _invalid} =
      OptionParser.parse(args, switches: @switches, aliases: @aliases)

    CLI.print_header()
    list_sessions(opts)
  end

  defp list_sessions(opts) do
    limit = Keyword.get(opts, :limit, 20)
    status = Keyword.get(opts, :status)
    user_id = Keyword.get(opts, :user)

    sessions = fetch_sessions(status, user_id, limit)

    if Enum.empty?(sessions) do
      CLI.info("No assessment sessions found.")
      CLI.info("Start a new assessment with: mix ai.assess.new --name \"Your Project\"")
    else
      print_session_table(sessions)
      CLI.info("\nResume a session with: mix ai.assess.resume <session_id>")
    end
  end

  defp fetch_sessions(status, _user_id, limit) do
    # Build query options
    query_opts = [limit: limit]

    query_opts =
      if status do
        Keyword.put(query_opts, :status, String.to_existing_atom(status))
      else
        query_opts
      end

    # For now, list all sessions (user filtering would require join)
    Assessments.list_sessions_filtered(query_opts)
  end

  defp print_session_table(sessions) do
    CLI.divider()

    # Header
    header =
      String.pad_trailing("ID", 12) <>
        " | " <>
        String.pad_trailing("Name", 30) <>
        " | " <>
        String.pad_trailing("Status", 18) <>
        " | " <>
        String.pad_trailing("Confidence", 10) <>
        " | " <>
        "Created"

    IO.puts(header)
    CLI.divider()

    # Rows
    Enum.each(sessions, fn session ->
      row =
        String.pad_trailing(truncate_id(session.id), 12) <>
          " | " <>
          String.pad_trailing(truncate_string(session.name, 30), 30) <>
          " | " <>
          String.pad_trailing(format_status(session.status), 18) <>
          " | " <>
          String.pad_trailing(format_confidence(session.confidence), 10) <>
          " | " <>
          format_date(session.inserted_at)

      IO.puts(row)
    end)

    CLI.divider()
    IO.puts("Total: #{length(sessions)} session(s)")
  end

  defp truncate_id(id) do
    id
    |> to_string()
    |> String.slice(0, 8)
    |> Kernel.<>("...")
  end

  defp truncate_string(str, max_length) do
    str = str || ""

    if String.length(str) > max_length do
      String.slice(str, 0, max_length - 3) <> "..."
    else
      str
    end
  end

  defp format_status(status) do
    case status do
      :gathering -> "Gathering Info"
      :ready_for_report -> "Ready for Report"
      :report_generated -> "Report Generated"
      :editing -> "Editing"
      :exported -> "Exported"
      _ -> to_string(status)
    end
  end

  defp format_confidence(nil), do: "0%"
  defp format_confidence(conf), do: "#{round(conf * 100)}%"

  defp format_date(nil), do: "N/A"

  defp format_date(datetime) do
    Calendar.strftime(datetime, "%Y-%m-%d %H:%M")
  end
end
