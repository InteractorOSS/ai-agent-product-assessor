defmodule AiAgentProjectAssessor.InteractorClient.Workflows do
  @moduledoc """
  Interactor Workflows API client.

  Manages workflow instances for multi-session assessment state management.

  ## Concepts

  - **Workflow**: A state machine definition (e.g., "ai_project_assessment")
  - **Instance**: A running execution of a workflow (one per assessment)
  - **State**: Current position in the workflow (e.g., "gathering_info")
  - **Halting State**: A state that pauses for user input

  ## Assessment Workflow States

  1. `initial_input` - Process initial unstructured input
  2. `analyzing` - Calculate confidence scores
  3. `gathering_info` - Wait for user answers (halting)
  4. `ready_for_report` - Check if confidence >= 95%
  5. `generating_report` - Generate the report
  6. `report_ready` - Wait for user to view (halting)
  7. `editing` - User editing report (halting)
  8. `exported` - Terminal state

  ## Usage

      {:ok, client} = InteractorClient.new()
      {:ok, instance} = Workflows.create_instance(client, "user_123", %{input: "..."})
      {:ok, instance} = Workflows.resume(client, instance.id, "user_123", %{answers: [...]})
  """

  require Logger
  alias AiAgentProjectAssessor.InteractorClient

  @api_path "/api/v1/workflows"

  @type instance :: %{
          id: String.t(),
          workflow_name: String.t(),
          current_state: String.t(),
          data: map(),
          created_at: String.t(),
          updated_at: String.t()
        }

  @doc """
  Creates a new workflow instance for an assessment.

  ## Parameters

  - `client`: Authenticated InteractorClient
  - `namespace`: User/tenant identifier
  - `initial_data`: Initial data for the workflow (e.g., input text)

  ## Examples

      iex> Workflows.create_instance(client, "user_123", %{input: "My AI project idea..."})
      {:ok, %{id: "inst_xyz", current_state: "initial_input", ...}}

  """
  @spec create_instance(InteractorClient.t(), String.t(), map()) ::
          {:ok, instance()} | {:error, term()}
  def create_instance(%InteractorClient{} = client, namespace, initial_data \\ %{}) do
    with {:ok, client} <- InteractorClient.ensure_valid_token(client) do
      workflow_name = InteractorClient.workflow_name(client)
      url = "#{InteractorClient.core_url(client)}#{@api_path}/#{workflow_name}/instances"

      body = %{
        data: initial_data
      }

      headers = [
        InteractorClient.auth_header(client),
        {"Content-Type", "application/json"},
        {"X-Namespace", namespace}
      ]

      case Req.post(url, json: body, headers: headers) do
        {:ok, %Req.Response{status: status, body: %{"data" => data}}} when status in [200, 201] ->
          {:ok, parse_instance(data)}

        {:ok, %Req.Response{status: status, body: body}} ->
          Logger.error("Failed to create workflow instance: status=#{status}")
          {:error, {:api_error, status, body}}

        {:error, reason} ->
          Logger.error("Request failed: #{inspect(reason)}")
          {:error, {:request_failed, reason}}
      end
    end
  end

  @doc """
  Gets a workflow instance by ID.

  ## Examples

      iex> Workflows.get_instance(client, "inst_xyz", "user_123")
      {:ok, %{id: "inst_xyz", current_state: "gathering_info", data: %{...}}}

  """
  @spec get_instance(InteractorClient.t(), String.t(), String.t()) ::
          {:ok, instance()} | {:error, term()}
  def get_instance(%InteractorClient{} = client, instance_id, namespace) do
    with {:ok, client} <- InteractorClient.ensure_valid_token(client) do
      url = "#{InteractorClient.core_url(client)}#{@api_path}/instances/#{instance_id}"

      headers = [
        InteractorClient.auth_header(client),
        {"X-Namespace", namespace}
      ]

      case Req.get(url, headers: headers) do
        {:ok, %Req.Response{status: 200, body: %{"data" => data}}} ->
          {:ok, parse_instance(data)}

        {:ok, %Req.Response{status: 404}} ->
          {:error, :not_found}

        {:ok, %Req.Response{status: status, body: body}} ->
          {:error, {:api_error, status, body}}

        {:error, reason} ->
          {:error, {:request_failed, reason}}
      end
    end
  end

  @doc """
  Resumes a workflow instance that's in a halting state.

  Used to provide user input (answers) to continue the workflow.

  ## Parameters

  - `client`: Authenticated InteractorClient
  - `instance_id`: The workflow instance ID
  - `namespace`: User/tenant identifier
  - `input`: User input data (e.g., answers to questions)
  - `opts`: Optional parameters (e.g., `thread_id` for parallel execution)

  ## Examples

      iex> Workflows.resume(client, "inst_xyz", "user_123", %{answers: [...]})
      {:ok, %{id: "inst_xyz", current_state: "analyzing", ...}}

  """
  @spec resume(InteractorClient.t(), String.t(), String.t(), map(), keyword()) ::
          {:ok, instance()} | {:error, term()}
  def resume(%InteractorClient{} = client, instance_id, namespace, input, opts \\ []) do
    with {:ok, client} <- InteractorClient.ensure_valid_token(client) do
      url = "#{InteractorClient.core_url(client)}#{@api_path}/instances/#{instance_id}/resume"

      body = %{
        input: input,
        thread_id: Keyword.get(opts, :thread_id, "main")
      }

      headers = [
        InteractorClient.auth_header(client),
        {"Content-Type", "application/json"},
        {"X-Namespace", namespace}
      ]

      case Req.post(url, json: body, headers: headers, receive_timeout: 120_000) do
        {:ok, %Req.Response{status: 200, body: %{"data" => data}}} ->
          {:ok, parse_instance(data)}

        {:ok, %Req.Response{status: 409, body: body}} ->
          # Conflict - workflow not in a halting state
          {:error, {:not_halting, body}}

        {:ok, %Req.Response{status: status, body: body}} ->
          Logger.error("Failed to resume workflow: status=#{status}")
          {:error, {:api_error, status, body}}

        {:error, reason} ->
          Logger.error("Request failed: #{inspect(reason)}")
          {:error, {:request_failed, reason}}
      end
    end
  end

  @doc """
  Gets the current data from a workflow instance.

  Useful for retrieving extracted information, confidence scores, etc.

  ## Examples

      iex> Workflows.get_instance_data(client, "inst_xyz", "user_123")
      {:ok, %{
        extracted_info: %{...},
        confidence_scores: %{...},
        pending_questions: [...]
      }}

  """
  @spec get_instance_data(InteractorClient.t(), String.t(), String.t()) ::
          {:ok, map()} | {:error, term()}
  def get_instance_data(%InteractorClient{} = client, instance_id, namespace) do
    case get_instance(client, instance_id, namespace) do
      {:ok, instance} -> {:ok, instance.data}
      error -> error
    end
  end

  @doc """
  Lists workflow instances for a namespace.

  ## Options

  - `:status` - Filter by status (e.g., "active", "completed")
  - `:limit` - Maximum number of results
  - `:offset` - Pagination offset

  ## Examples

      iex> Workflows.list_instances(client, "user_123", status: "active")
      {:ok, [%{id: "inst_1", ...}, %{id: "inst_2", ...}]}

  """
  @spec list_instances(InteractorClient.t(), String.t(), keyword()) ::
          {:ok, [instance()]} | {:error, term()}
  def list_instances(%InteractorClient{} = client, namespace, opts \\ []) do
    with {:ok, client} <- InteractorClient.ensure_valid_token(client) do
      workflow_name = InteractorClient.workflow_name(client)
      url = "#{InteractorClient.core_url(client)}#{@api_path}/#{workflow_name}/instances"

      headers = [
        InteractorClient.auth_header(client),
        {"X-Namespace", namespace}
      ]

      params = Keyword.take(opts, [:status, :limit, :offset])

      case Req.get(url, headers: headers, params: params) do
        {:ok, %Req.Response{status: 200, body: %{"data" => data}}} ->
          {:ok, Enum.map(data, &parse_instance/1)}

        {:ok, %Req.Response{status: status, body: body}} ->
          {:error, {:api_error, status, body}}

        {:error, reason} ->
          {:error, {:request_failed, reason}}
      end
    end
  end

  @doc """
  Checks if a workflow instance is in a halting state (waiting for input).

  ## Examples

      iex> Workflows.halting?(instance)
      true

  """
  @spec halting?(instance()) :: boolean()
  def halting?(%{current_state: state}) do
    state in ["gathering_info", "report_ready", "editing"]
  end

  @doc """
  Checks if a workflow instance has completed.

  ## Examples

      iex> Workflows.completed?(instance)
      true

  """
  @spec completed?(instance()) :: boolean()
  def completed?(%{current_state: state}) do
    state == "exported"
  end

  @doc """
  Extracts the confidence score from workflow data.

  ## Examples

      iex> Workflows.get_confidence(instance)
      0.85

  """
  @spec get_confidence(instance()) :: float()
  def get_confidence(%{data: data}) do
    get_in(data, ["confidence_scores", "overall"]) || 0.0
  end

  @doc """
  Extracts pending questions from workflow data.

  ## Examples

      iex> Workflows.get_pending_questions(instance)
      [%{dimension: "data_availability", question: "..."}]

  """
  @spec get_pending_questions(instance()) :: [map()]
  def get_pending_questions(%{data: data}) do
    data["pending_questions"] || []
  end

  # Private functions

  defp parse_instance(data) do
    %{
      id: data["id"],
      workflow_name: data["workflow_name"] || data["name"],
      current_state: data["current_state"],
      data: data["data"] || %{},
      created_at: data["created_at"],
      updated_at: data["updated_at"]
    }
  end
end
