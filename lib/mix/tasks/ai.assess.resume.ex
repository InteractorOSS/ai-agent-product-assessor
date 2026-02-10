defmodule Mix.Tasks.Ai.Assess.Resume do
  @shortdoc "Resume an existing AI project assessment"

  @moduledoc """
  Resumes an existing AI project assessment session.

  ## Usage

      mix ai.assess.resume <session_id>

  ## Arguments

    * `session_id` - The ID of the session to resume (required)

  ## Examples

      # Resume a specific session
      mix ai.assess.resume abc123-def456-...

      # List available sessions first
      mix ai.assess.list

  ## Finding Session IDs

  Use `mix ai.assess.list` to see all your assessment sessions and their IDs.
  """

  use Mix.Task

  alias AiAgentProjectAssessor.CLI
  alias AiAgentProjectAssessor.Assessments
  alias AiAgentProjectAssessor.AssessmentEngine

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")

    case args do
      [session_id | _] ->
        resume_session(session_id)

      [] ->
        CLI.error("Session ID is required")
        CLI.info("Usage: mix ai.assess.resume <session_id>")
        CLI.info("Run `mix ai.assess.list` to see available sessions")
        exit({:shutdown, 1})
    end
  end

  defp resume_session(session_id) do
    CLI.print_header()
    CLI.info("Resuming session: #{session_id}")

    case Assessments.get_session(session_id) do
      nil ->
        CLI.error("Session not found: #{session_id}")
        CLI.info("Run `mix ai.assess.list` to see available sessions")
        exit({:shutdown, 1})

      session ->
        if session.status == :exported do
          CLI.warn("This session has been completed and exported.")
          CLI.info("Start a new assessment with: mix ai.assess.new")
          exit({:shutdown, 0})
        end

        CLI.success("Found session: #{session.name}")
        CLI.print_status(session)

        case AssessmentEngine.resume_assessment(session) do
          {:ok, engine_state} ->
            CLI.print_ai(engine_state.last_response)
            # Reuse the conversation loop from the new task
            run_conversation_loop(session, engine_state)

          {:error, reason} ->
            CLI.error("Failed to resume assessment: #{inspect(reason)}")
            exit({:shutdown, 1})
        end
    end
  end

  defp run_conversation_loop(session, engine_state) do
    input = CLI.prompt("You: ")

    case input do
      nil ->
        handle_command("quit", "", session, engine_state)

      "" ->
        run_conversation_loop(session, engine_state)

      input ->
        case CLI.parse_input(input) do
          {:command, command, args} ->
            handle_command(command, args, session, engine_state)

          {:text, text} ->
            handle_user_input(text, session, engine_state)
        end
    end
  end

  defp handle_command("quit", _args, session, engine_state) do
    if CLI.confirm?("Exit without saving?") do
      CLI.warn("Session not saved. Use `mix ai.assess.resume #{session.id}` to continue.")
      :ok
    else
      run_conversation_loop(session, engine_state)
    end
  end

  defp handle_command("save", _args, session, engine_state) do
    CLI.info("Saving session...")

    case AssessmentEngine.save_state(session, engine_state) do
      {:ok, updated_session} ->
        CLI.success("Session saved!")
        CLI.info("Resume with: mix ai.assess.resume #{updated_session.id}")
        :ok

      {:error, reason} ->
        CLI.error("Failed to save: #{inspect(reason)}")
        run_conversation_loop(session, engine_state)
    end
  end

  defp handle_command("status", _args, session, engine_state) do
    session = Assessments.get_session!(session.id)
    CLI.print_status(session)

    if engine_state.dimensions_data do
      CLI.print_dimensions(engine_state.dimensions_data)
    end

    CLI.print_progress_bar(session.confidence)
    run_conversation_loop(session, engine_state)
  end

  defp handle_command("report", _args, session, engine_state) do
    session = Assessments.get_session!(session.id)

    if session.confidence >= 0.95 do
      CLI.info("Generating report...")

      case AssessmentEngine.generate_report(session, engine_state) do
        {:ok, report} ->
          CLI.success("Report generated!")
          CLI.info("View at: http://localhost:4000/reports/#{report.id}")
          :ok

        {:error, reason} ->
          CLI.error("Failed to generate report: #{inspect(reason)}")
          run_conversation_loop(session, engine_state)
      end
    else
      CLI.warn("Not ready for report generation.")
      CLI.info("Current confidence: #{round(session.confidence * 100)}%")
      CLI.info("Continue answering questions to reach 95% confidence.")
      run_conversation_loop(session, engine_state)
    end
  end

  defp handle_command("help", _args, session, engine_state) do
    CLI.print_help()
    run_conversation_loop(session, engine_state)
  end

  defp handle_command(unknown, _args, session, engine_state) do
    CLI.warn("Unknown command: /#{unknown}")
    CLI.info("Type /help for available commands")
    run_conversation_loop(session, engine_state)
  end

  defp handle_user_input(text, session, engine_state) do
    case AssessmentEngine.process_input(session, engine_state, text) do
      {:ok, new_state} ->
        {:ok, updated_session} =
          Assessments.update_session(session, %{
            confidence: new_state.confidence,
            dimensions_complete: new_state.dimensions_complete
          })

        CLI.print_ai(new_state.last_response)

        if new_state.confidence >= 0.95 and session.confidence < 0.95 do
          CLI.success("Assessment complete! Confidence threshold reached.")
          CLI.info("Type /report to generate the assessment report.")
        end

        run_conversation_loop(updated_session, new_state)

      {:error, reason} ->
        CLI.error("Error processing input: #{inspect(reason)}")
        run_conversation_loop(session, engine_state)
    end
  end
end
