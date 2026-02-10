defmodule AiAgentProjectAssessor.InteractorSetup do
  @moduledoc """
  Ensures Interactor services are properly configured on application startup.

  This module:
  1. Authenticates with Interactor using OAuth credentials
  2. Creates or retrieves the AI assessment assistant
  3. Stores the assistant ID for use by the application

  ## Configuration

  Requires the following environment variables:
  - `INTERACTOR_AUTH_CLIENT_ID`: OAuth client ID
  - `INTERACTOR_AUTH_CLIENT_SECRET`: OAuth client secret
  - `INTERACTOR_URL`: Auth server URL (optional, defaults to https://auth.interactor.com)
  - `INTERACTOR_CORE_URL`: Core API URL (optional, defaults to https://core.interactor.com)

  ## Usage

  Add to your application supervision tree:

      children = [
        # ... other children
        AiAgentProjectAssessor.InteractorSetup,
        # ... rest of children
      ]

  The setup runs asynchronously and won't block application startup.
  """

  use GenServer
  require Logger

  alias AiAgentProjectAssessor.InteractorClient
  alias AiAgentProjectAssessor.InteractorClient.Agents

  @assistant_name "ai_project_assessor"

  # ============================================================================
  # Public API
  # ============================================================================

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
  Returns the configured assistant ID, or nil if not yet set up.
  """
  def get_assistant_id do
    GenServer.call(__MODULE__, :get_assistant_id)
  catch
    :exit, _ -> nil
  end

  @doc """
  Checks if Interactor is connected and ready.
  """
  def connected? do
    case GenServer.call(__MODULE__, :status) do
      :connected -> true
      _ -> false
    end
  catch
    :exit, _ -> false
  end

  @doc """
  Returns the current status.
  """
  def status do
    GenServer.call(__MODULE__, :status)
  catch
    :exit, _ -> :not_started
  end

  @doc """
  Manually triggers setup retry (useful if initial setup failed).
  """
  def retry_setup do
    GenServer.cast(__MODULE__, :setup)
  end

  # ============================================================================
  # GenServer Callbacks
  # ============================================================================

  @impl true
  def init(_opts) do
    state = %{
      status: :initializing,
      assistant_id: nil,
      error: nil
    }

    # Run setup asynchronously so we don't block application startup
    send(self(), :setup)

    {:ok, state}
  end

  @impl true
  def handle_info(:setup, state) do
    new_state = do_setup(state)
    {:noreply, new_state}
  end

  @impl true
  def handle_call(:get_assistant_id, _from, state) do
    {:reply, state.assistant_id, state}
  end

  @impl true
  def handle_call(:status, _from, state) do
    {:reply, state.status, state}
  end

  @impl true
  def handle_cast(:setup, state) do
    new_state = do_setup(%{state | status: :initializing, error: nil})
    {:noreply, new_state}
  end

  # ============================================================================
  # Private - Setup Logic
  # ============================================================================

  defp do_setup(state) do
    Logger.info("[InteractorSetup] Starting Interactor setup...")

    case InteractorClient.new() do
      {:ok, client} ->
        Logger.info("[InteractorSetup] Authenticated with Interactor")
        ensure_assistant_exists(state, client)

      {:error, :not_configured} ->
        Logger.warning("[InteractorSetup] Interactor credentials not configured - running in offline mode")
        %{state | status: :offline, error: :not_configured}

      {:error, :unauthorized} ->
        Logger.error("[InteractorSetup] Interactor authentication failed - check credentials")
        %{state | status: :auth_failed, error: :unauthorized}

      {:error, reason} ->
        Logger.error("[InteractorSetup] Failed to connect to Interactor: #{inspect(reason)}")
        schedule_retry()
        %{state | status: :connection_failed, error: reason}
    end
  end

  defp ensure_assistant_exists(state, client) do
    # First check if we already have an assistant ID configured
    configured_id = get_configured_assistant_id()

    if configured_id do
      # Verify the configured assistant exists
      case Agents.get_assistant(client, configured_id) do
        {:ok, assistant} ->
          Logger.info("[InteractorSetup] Using configured assistant: #{assistant.id}")
          %{state | status: :connected, assistant_id: assistant.id}

        {:error, :not_found} ->
          Logger.warning("[InteractorSetup] Configured assistant not found, creating new one")
          create_or_find_assistant(state, client)

        {:error, reason} ->
          Logger.error("[InteractorSetup] Failed to verify assistant: #{inspect(reason)}")
          %{state | status: :error, error: reason}
      end
    else
      create_or_find_assistant(state, client)
    end
  end

  defp create_or_find_assistant(state, client) do
    # First, try to find existing assistant by name
    case Agents.list_assistants(client) do
      {:ok, assistants} ->
        case Enum.find(assistants, &(&1.name == @assistant_name)) do
          nil ->
            # No existing assistant, create one
            create_assistant(state, client)

          existing ->
            Logger.info("[InteractorSetup] Found existing assistant: #{existing.id}")
            store_assistant_id(existing.id)
            %{state | status: :connected, assistant_id: existing.id}
        end

      {:error, reason} ->
        Logger.error("[InteractorSetup] Failed to list assistants: #{inspect(reason)}")
        # Try to create anyway
        create_assistant(state, client)
    end
  end

  defp create_assistant(state, client) do
    Logger.info("[InteractorSetup] Creating AI Project Assessor assistant...")

    config = %{
      name: @assistant_name,
      title: "AI Project Assessor",
      description: "Expert AI system for evaluating AI agent project ideas across 12 key dimensions",
      instructions: assessment_instructions(),
      model_config: %{
        "provider" => "anthropic",
        "model" => "claude-sonnet-4-20250514",
        "temperature" => 0.7
      }
    }

    case Agents.create_assistant(client, config) do
      {:ok, assistant} ->
        Logger.info("[InteractorSetup] Assistant created successfully: #{assistant.id}")
        store_assistant_id(assistant.id)
        %{state | status: :connected, assistant_id: assistant.id}

      {:error, {:already_exists, _}} ->
        # Race condition - assistant was created by another instance
        # Try to find it
        Logger.info("[InteractorSetup] Assistant already exists, finding it...")
        create_or_find_assistant(state, client)

      {:error, reason} ->
        Logger.error("[InteractorSetup] Failed to create assistant: #{inspect(reason)}")
        schedule_retry()
        %{state | status: :error, error: reason}
    end
  end

  defp get_configured_assistant_id do
    Application.get_env(:ai_agent_project_assessor, AiAgentProjectAssessor.InteractorClient)
    |> Keyword.get(:assistant_id)
  end

  defp store_assistant_id(assistant_id) do
    # Update runtime config so other parts of the app can use it
    current_config =
      Application.get_env(:ai_agent_project_assessor, AiAgentProjectAssessor.InteractorClient, [])

    updated_config = Keyword.put(current_config, :assistant_id, assistant_id)

    Application.put_env(
      :ai_agent_project_assessor,
      AiAgentProjectAssessor.InteractorClient,
      updated_config
    )

    Logger.info("[InteractorSetup] Stored assistant ID in application config: #{assistant_id}")
  end

  defp schedule_retry do
    # Retry setup after 30 seconds
    Process.send_after(self(), :setup, 30_000)
    Logger.info("[InteractorSetup] Will retry setup in 30 seconds")
  end

  defp assessment_instructions do
    """
    You are an expert AI Project Assessor. Your role is to help decision makers evaluate AI agent project ideas through structured conversation.

    ## Your Methodology

    You assess projects across 12 key dimensions:

    1. **Problem Statement** - Is the problem clear, specific, and measurable?
    2. **Solution Approach** - What AI/ML approach is proposed? Is AI the right tool?
    3. **Data Availability** - What data is available? Is it accessible and sufficient?
    4. **Data Quality** - Is the data clean, labeled, and complete?
    5. **Technical Feasibility** - Can this be built? What infrastructure is needed?
    6. **Integration Requirements** - What systems must this integrate with?
    7. **Success Criteria** - How will success be measured? What KPIs matter?
    8. **User Requirements** - Who are the users? What's their technical level?
    9. **Constraints** - Budget, timeline, regulatory, security constraints?
    10. **Risk Factors** - What could go wrong? What are the blockers?
    11. **Timeline** - What's the target timeline? Are there hard deadlines?
    12. **Budget** - What's the budget? What ongoing costs are acceptable?

    ## Your Approach

    1. **Accept any input format** - Users may provide meeting transcripts, product briefs, casual descriptions, or structured specs. Extract what you can.

    2. **Identify gaps** - After processing input, clearly identify what information is missing.

    3. **Ask targeted questions** - Focus on the dimensions with lowest confidence. Be specific.

    4. **Track confidence** - Internally track how confident you are about each dimension (0-100%).

    5. **Guide to completion** - Help users reach 95%+ confidence across all dimensions.

    6. **Be conversational** - This is a discussion, not a form. Adapt to the user's style.

    ## Response Format

    After each user input:
    1. Acknowledge what you learned
    2. Update your understanding (show progress when helpful)
    3. Ask 2-3 focused questions about the lowest-confidence dimensions
    4. Explain why you're asking (optional, but helps engagement)

    When confidence reaches 95%+, indicate the assessment is complete and ready for report generation.

    ## Tone

    - Professional but approachable
    - Ask clarifying questions, don't assume
    - Be honest about limitations and risks
    - Focus on helping the user make a good decision
    """
  end
end
