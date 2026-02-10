defmodule AiAgentProjectAssessor.InteractorClient do
  @moduledoc """
  Main entry point for Interactor platform integration.

  This module provides a unified interface to Interactor services:
  - Auth: OAuth authentication and token management
  - Agents: AI assistant rooms and messages
  - Workflows: State machine for multi-session assessments

  ## Configuration

  Configure in `config/runtime.exs`:

      config :ai_agent_project_assessor, AiAgentProjectAssessor.InteractorClient,
        client_id: System.get_env("INTERACTOR_CLIENT_ID"),
        client_secret: System.get_env("INTERACTOR_CLIENT_SECRET"),
        auth_url: System.get_env("INTERACTOR_URL", "https://auth.interactor.com"),
        core_url: System.get_env("INTERACTOR_CORE_URL", "https://core.interactor.com"),
        assistant_id: System.get_env("INTERACTOR_ASSISTANT_ID"),
        workflow_name: System.get_env("INTERACTOR_WORKFLOW_NAME", "ai_project_assessment")

  ## Usage

      # Get authenticated client
      {:ok, client} = AiAgentProjectAssessor.InteractorClient.new()

      # Use submodules
      {:ok, room} = AiAgentProjectAssessor.InteractorClient.Agents.create_room(client, "user_123")
      {:ok, instance} = AiAgentProjectAssessor.InteractorClient.Workflows.create_instance(client, "user_123", data)
  """

  alias AiAgentProjectAssessor.InteractorClient.Auth

  @type t :: %__MODULE__{
          access_token: String.t() | nil,
          token_expires_at: DateTime.t() | nil,
          config: map()
        }

  defstruct [:access_token, :token_expires_at, :config]

  @doc """
  Creates a new authenticated Interactor client.

  Fetches an access token using client credentials flow.

  ## Examples

      iex> InteractorClient.new()
      {:ok, %InteractorClient{}}

      iex> InteractorClient.new(client_id: "...", client_secret: "...")
      {:ok, %InteractorClient{}}

  """
  def new(opts \\ []) do
    config = build_config(opts)

    with {:ok, token_data} <- Auth.fetch_token(config) do
      client = %__MODULE__{
        access_token: token_data.access_token,
        token_expires_at: token_data.expires_at,
        config: config
      }

      {:ok, client}
    end
  end

  @doc """
  Ensures the client has a valid access token.

  Refreshes the token if it's expired or about to expire.

  ## Examples

      iex> InteractorClient.ensure_valid_token(client)
      {:ok, %InteractorClient{}}

  """
  def ensure_valid_token(%__MODULE__{} = client) do
    if token_expired?(client) do
      refresh_token(client)
    else
      {:ok, client}
    end
  end

  @doc """
  Checks if the current token is expired or about to expire.

  Considers a token expired if it expires within 60 seconds.
  """
  def token_expired?(%__MODULE__{token_expires_at: nil}), do: true

  def token_expired?(%__MODULE__{token_expires_at: expires_at}) do
    buffer_seconds = 60
    DateTime.compare(expires_at, DateTime.add(DateTime.utc_now(), buffer_seconds)) != :gt
  end

  @doc """
  Refreshes the access token.
  """
  def refresh_token(%__MODULE__{config: config} = client) do
    case Auth.fetch_token(config) do
      {:ok, token_data} ->
        {:ok,
         %{
           client
           | access_token: token_data.access_token,
             token_expires_at: token_data.expires_at
         }}

      error ->
        error
    end
  end

  @doc """
  Returns the authorization header for API requests.
  """
  def auth_header(%__MODULE__{access_token: token}) do
    {"Authorization", "Bearer #{token}"}
  end

  @doc """
  Returns the base URL for the Core API.
  """
  def core_url(%__MODULE__{config: config}) do
    Map.get(config, :core_url, "https://core.interactor.com")
  end

  @doc """
  Returns the configured assistant ID.

  Falls back to dynamically retrieved ID from InteractorSetup if not in config.
  """
  def assistant_id(%__MODULE__{config: config}) do
    case Map.get(config, :assistant_id) do
      nil ->
        # Try to get from InteractorSetup (dynamically created)
        case AiAgentProjectAssessor.InteractorSetup.get_assistant_id() do
          nil -> raise "No assistant ID configured or created"
          id -> id
        end

      id ->
        id
    end
  end

  @doc """
  Returns the configured workflow name.
  """
  def workflow_name(%__MODULE__{config: config}) do
    Map.get(config, :workflow_name, "ai_project_assessment")
  end

  # Private functions

  defp build_config(opts) do
    app_config =
      Application.get_env(:ai_agent_project_assessor, __MODULE__, [])
      |> Enum.into(%{})

    defaults = %{
      auth_url: "https://auth.interactor.com",
      core_url: "https://core.interactor.com",
      workflow_name: "ai_project_assessment"
    }

    defaults
    |> Map.merge(app_config)
    |> Map.merge(Enum.into(opts, %{}))
  end
end
