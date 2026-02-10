defmodule Mix.Tasks.Ai.Assess.New do
  @shortdoc "Start a new AI project assessment"

  @moduledoc """
  Starts a new AI project assessment session.

  ## Usage

      mix ai.assess.new [options]

  ## Options

    * `--name`, `-n` - Name for the assessment session (required)
    * `--input`, `-i` - Path to a file containing initial project description
    * `--user`, `-u` - User identifier (defaults to current system user)

  ## Examples

      # Interactive mode - you'll be prompted for the project description
      mix ai.assess.new --name "Customer Support Bot"

      # With input file
      mix ai.assess.new --name "Customer Support Bot" --input project_idea.txt

  ## Conversation Flow

  Once started, the assessment will:
  1. Process your initial project description
  2. Ask clarifying questions to fill in missing information
  3. Track progress across 12 assessment dimensions
  4. Generate a report when confidence reaches 95%

  ## Commands During Assessment

  While in an assessment session, you can use these commands:
    * `/status` - Show current progress
    * `/save` - Save and exit (can resume later)
    * `/report` - Generate report (when ready)
    * `/help` - Show available commands
    * `/quit` - Exit without saving
  """

  use Mix.Task

  alias AiAgentProjectAssessor.CLI
  alias AiAgentProjectAssessor.Accounts
  alias AiAgentProjectAssessor.Assessments
  alias AiAgentProjectAssessor.AssessmentEngine

  @switches [
    name: :string,
    input: :string,
    user: :string
  ]

  @aliases [
    n: :name,
    i: :input,
    u: :user
  ]

  @impl Mix.Task
  def run(args) do
    # Start the application
    Mix.Task.run("app.start")

    # Parse arguments
    {opts, _remaining, _invalid} =
      OptionParser.parse(args, switches: @switches, aliases: @aliases)

    CLI.print_header()

    case validate_opts(opts) do
      {:ok, validated_opts} ->
        start_assessment(validated_opts)

      {:error, message} ->
        CLI.error(message)
        CLI.info("Run `mix help ai.assess.new` for usage information")
        exit({:shutdown, 1})
    end
  end

  defp validate_opts(opts) do
    name = Keyword.get(opts, :name)

    if is_nil(name) or name == "" do
      {:error, "Assessment name is required. Use --name \"Your Project Name\""}
    else
      {:ok,
       %{
         name: name,
         input_file: Keyword.get(opts, :input),
         user_id: Keyword.get(opts, :user, get_default_user())
       }}
    end
  end

  defp get_default_user do
    System.get_env("USER") || System.get_env("USERNAME") || "anonymous"
  end

  defp start_assessment(opts) do
    CLI.info("Starting new assessment: #{opts.name}")

    # Get or create user
    case get_or_create_user(opts.user_id) do
      {:ok, user} ->
        # Get initial input
        initial_input = get_initial_input(opts)

        if initial_input == "" or is_nil(initial_input) do
          CLI.error(
            "No project description provided. Please provide input interactively or via --input file."
          )

          exit({:shutdown, 1})
        end

        # Create the assessment session
        case create_session(user, opts.name, initial_input) do
          {:ok, session} ->
            CLI.success("Session created: #{session.id}")
            CLI.info("Processing your input...")

            # Start the conversation loop
            run_conversation_loop(session, user)

          {:error, reason} ->
            CLI.error("Failed to create session: #{inspect(reason)}")
            exit({:shutdown, 1})
        end

      {:error, reason} ->
        CLI.error("Failed to initialize user: #{inspect(reason)}")
        exit({:shutdown, 1})
    end
  end

  defp get_or_create_user(user_id) do
    # For CLI users, we create a local user with a generated interactor_id
    case Accounts.get_user_by_interactor_id("cli:#{user_id}") do
      nil ->
        Accounts.create_user(%{
          interactor_id: "cli:#{user_id}",
          email: "#{user_id}@cli.local",
          name: user_id
        })

      user ->
        {:ok, user}
    end
  end

  defp get_initial_input(opts) do
    case opts.input_file do
      nil ->
        # Interactive mode
        CLI.info("Please describe your AI project idea.")
        CLI.prompt_multiline("What problem are you trying to solve with AI?")

      file_path ->
        # Read from file
        case File.read(file_path) do
          {:ok, content} ->
            CLI.success("Loaded input from: #{file_path}")
            String.trim(content)

          {:error, reason} ->
            CLI.error("Could not read file #{file_path}: #{inspect(reason)}")
            exit({:shutdown, 1})
        end
    end
  end

  defp create_session(user, name, initial_input) do
    Assessments.create_session(%{
      user_id: user.id,
      name: name,
      initial_input: initial_input,
      status: :gathering
    })
  end

  defp run_conversation_loop(session, user) do
    # Initialize the assessment engine
    case AssessmentEngine.start_assessment(session) do
      {:ok, engine_state} ->
        # Show initial AI response
        CLI.print_ai(engine_state.last_response)

        # Enter the main loop
        conversation_loop(session, user, engine_state)

      {:error, reason} ->
        CLI.error("Failed to start assessment engine: #{inspect(reason)}")
        exit({:shutdown, 1})
    end
  end

  defp conversation_loop(session, user, engine_state) do
    # Show prompt
    input = CLI.prompt("You: ")

    case input do
      nil ->
        # EOF received
        handle_command("quit", "", session, user, engine_state)

      "" ->
        # Empty input, continue loop
        conversation_loop(session, user, engine_state)

      input ->
        case CLI.parse_input(input) do
          {:command, command, args} ->
            handle_command(command, args, session, user, engine_state)

          {:text, text} ->
            handle_user_input(text, session, user, engine_state)
        end
    end
  end

  defp handle_command("quit", _args, session, user, engine_state) do
    if CLI.confirm?("Exit without saving?") do
      CLI.warn("Session not saved. Use `mix ai.assess.resume #{session.id}` to continue.")
      :ok
    else
      conversation_loop(session, user, engine_state)
    end
  end

  defp handle_command("save", _args, session, user, engine_state) do
    CLI.info("Saving session...")

    case AssessmentEngine.save_state(session, engine_state) do
      {:ok, updated_session} ->
        CLI.success("Session saved!")
        CLI.info("Resume with: mix ai.assess.resume #{updated_session.id}")
        :ok

      {:error, reason} ->
        CLI.error("Failed to save: #{inspect(reason)}")
        conversation_loop(session, user, engine_state)
    end
  end

  defp handle_command("status", _args, session, user, engine_state) do
    # Refresh session from DB
    session = Assessments.get_session!(session.id)
    CLI.print_status(session)

    if engine_state.dimensions_data do
      CLI.print_dimensions(engine_state.dimensions_data)
    end

    CLI.print_progress_bar(session.confidence)
    conversation_loop(session, user, engine_state)
  end

  defp handle_command("report", _args, session, user, engine_state) do
    session = Assessments.get_session!(session.id)

    if session.confidence >= 0.95 do
      CLI.info("Generating report...")

      case AssessmentEngine.generate_report(session, engine_state) do
        {:ok, report} ->
          CLI.success("Report generated!")
          CLI.info("View at: http://localhost:4000/reports/#{report.id}")
          CLI.info("Export with: mix ai.assess.export #{session.id}")
          :ok

        {:error, reason} ->
          CLI.error("Failed to generate report: #{inspect(reason)}")
          conversation_loop(session, user, engine_state)
      end
    else
      CLI.warn("Not ready for report generation.")
      CLI.info("Current confidence: #{round(session.confidence * 100)}%")
      CLI.info("Continue answering questions to reach 95% confidence.")
      conversation_loop(session, user, engine_state)
    end
  end

  defp handle_command("help", _args, session, user, engine_state) do
    CLI.print_help()
    conversation_loop(session, user, engine_state)
  end

  defp handle_command(unknown, _args, session, user, engine_state) do
    CLI.warn("Unknown command: /#{unknown}")
    CLI.info("Type /help for available commands")
    conversation_loop(session, user, engine_state)
  end

  defp handle_user_input(text, session, user, engine_state) do
    # Process user input through the assessment engine
    case AssessmentEngine.process_input(session, engine_state, text) do
      {:ok, new_state} ->
        # Update session with new state
        {:ok, updated_session} =
          Assessments.update_session(session, %{
            confidence: new_state.confidence,
            dimensions_complete: new_state.dimensions_complete
          })

        # Display AI response
        CLI.print_ai(new_state.last_response)

        # Check if we've reached the threshold
        if new_state.confidence >= 0.95 and session.confidence < 0.95 do
          CLI.success("Assessment complete! Confidence threshold reached.")
          CLI.info("Type /report to generate the assessment report.")
        end

        conversation_loop(updated_session, user, new_state)

      {:error, reason} ->
        CLI.error("Error processing input: #{inspect(reason)}")
        conversation_loop(session, user, engine_state)
    end
  end
end
