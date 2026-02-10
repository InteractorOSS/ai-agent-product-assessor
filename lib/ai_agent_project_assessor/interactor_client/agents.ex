defmodule AiAgentProjectAssessor.InteractorClient.Agents do
  @moduledoc """
  Interactor Agents API client.

  Manages AI assistant rooms and messages for assessment conversations.

  ## Concepts

  - **Assistant**: The AI model configured for project assessment
  - **Room**: A conversation context (one per assessment session)
  - **Message**: Individual messages in a conversation
  - **Namespace**: User/tenant isolation identifier

  ## Usage

      {:ok, client} = InteractorClient.new()
      {:ok, room} = Agents.create_room(client, "user_123", %{session_id: "..."})
      {:ok, message} = Agents.send_message(client, room.id, "Here's my AI project idea...")
  """

  require Logger
  alias AiAgentProjectAssessor.InteractorClient

  @api_path "/api/v1/agents"

  @type room :: %{
          id: String.t(),
          assistant_id: String.t(),
          namespace: String.t(),
          metadata: map(),
          created_at: String.t()
        }

  @type message :: %{
          id: String.t(),
          room_id: String.t(),
          role: String.t(),
          content: String.t(),
          created_at: String.t()
        }

  @doc """
  Creates a new agent room for an assessment conversation.

  ## Parameters

  - `client`: Authenticated InteractorClient
  - `namespace`: User/tenant identifier (e.g., "user_123")
  - `metadata`: Optional metadata to attach to the room

  ## Examples

      iex> Agents.create_room(client, "user_123", %{session_id: "abc"})
      {:ok, %{id: "room_xyz", ...}}

  """
  @spec create_room(InteractorClient.t(), String.t(), map()) :: {:ok, room()} | {:error, term()}
  def create_room(%InteractorClient{} = client, namespace, metadata \\ %{}) do
    with {:ok, client} <- InteractorClient.ensure_valid_token(client) do
      assistant_id = InteractorClient.assistant_id(client)
      url = "#{InteractorClient.core_url(client)}#{@api_path}/#{assistant_id}/rooms"

      # Per API docs: namespace goes in body, not header
      body = %{
        namespace: namespace,
        metadata: metadata
      }

      headers = [
        InteractorClient.auth_header(client),
        {"Content-Type", "application/json"}
      ]

      Logger.info("[Interactor] Creating room for assistant #{assistant_id}, namespace: #{namespace}")

      case Req.post(url, json: body, headers: headers) do
        {:ok, %Req.Response{status: status, body: %{"data" => data}}} when status in [200, 201] ->
          Logger.info("[Interactor] Room created: #{data["id"]}")
          {:ok, parse_room(data)}

        {:ok, %Req.Response{status: status, body: body}} ->
          Logger.error("[Interactor] Failed to create room: status=#{status}, body=#{inspect(body)}")
          {:error, {:api_error, status, body}}

        {:error, reason} ->
          Logger.error("[Interactor] Request failed: #{inspect(reason)}")
          {:error, {:request_failed, reason}}
      end
    end
  end

  @doc """
  Gets an existing room by ID.

  ## Examples

      iex> Agents.get_room(client, "room_xyz", "user_123")
      {:ok, %{id: "room_xyz", ...}}

  """
  @spec get_room(InteractorClient.t(), String.t(), String.t()) :: {:ok, room()} | {:error, term()}
  def get_room(%InteractorClient{} = client, room_id, _namespace) do
    with {:ok, client} <- InteractorClient.ensure_valid_token(client) do
      url = "#{InteractorClient.core_url(client)}#{@api_path}/rooms/#{room_id}"

      headers = [
        InteractorClient.auth_header(client)
      ]

      case Req.get(url, headers: headers) do
        {:ok, %Req.Response{status: 200, body: %{"data" => data}}} ->
          {:ok, parse_room(data)}

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
  Sends a message to a room and gets the AI response.

  ## Examples

      iex> Agents.send_message(client, "room_xyz", "Here's my project idea...", "user_123")
      {:ok, %{id: "msg_abc", role: "assistant", content: "...", ...}}

  """
  @spec send_message(InteractorClient.t(), String.t(), String.t(), String.t()) ::
          {:ok, message()} | {:error, term()}
  def send_message(%InteractorClient{} = client, room_id, content, _namespace) do
    with {:ok, client} <- InteractorClient.ensure_valid_token(client) do
      url = "#{InteractorClient.core_url(client)}#{@api_path}/rooms/#{room_id}/messages"

      # Per API docs: include role: "user" for user messages
      body = %{
        content: content,
        role: "user"
      }

      headers = [
        InteractorClient.auth_header(client),
        {"Content-Type", "application/json"}
      ]

      Logger.info("[Interactor] Sending message to room #{room_id} (#{String.length(content)} chars)")

      case Req.post(url, json: body, headers: headers, receive_timeout: 120_000) do
        {:ok, %Req.Response{status: status, body: %{"data" => data}}} when status in [200, 201] ->
          Logger.info("[Interactor] Message sent, got response from AI")
          {:ok, parse_message(data)}

        {:ok, %Req.Response{status: status, body: body}} ->
          Logger.error("[Interactor] Failed to send message: status=#{status}, body=#{inspect(body)}")
          {:error, {:api_error, status, body}}

        {:error, reason} ->
          Logger.error("[Interactor] Request failed: #{inspect(reason)}")
          {:error, {:request_failed, reason}}
      end
    end
  end

  @doc """
  Lists messages in a room.

  ## Examples

      iex> Agents.list_messages(client, "room_xyz", "user_123")
      {:ok, [%{id: "msg_1", ...}, %{id: "msg_2", ...}]}

  """
  @spec list_messages(InteractorClient.t(), String.t(), String.t(), keyword()) ::
          {:ok, [message()]} | {:error, term()}
  def list_messages(%InteractorClient{} = client, room_id, _namespace, opts \\ []) do
    with {:ok, client} <- InteractorClient.ensure_valid_token(client) do
      url = "#{InteractorClient.core_url(client)}#{@api_path}/rooms/#{room_id}/messages"

      headers = [
        InteractorClient.auth_header(client)
      ]

      params = Keyword.take(opts, [:limit, :before])

      case Req.get(url, headers: headers, params: params) do
        {:ok, %Req.Response{status: 200, body: %{"data" => data}}} ->
          {:ok, Enum.map(data, &parse_message/1)}

        {:ok, %Req.Response{status: status, body: body}} ->
          {:error, {:api_error, status, body}}

        {:error, reason} ->
          {:error, {:request_failed, reason}}
      end
    end
  end

  @doc """
  Initiates a streaming response from the AI.

  Returns a stream that yields message chunks.

  ## Examples

      iex> stream = Agents.stream_response(client, "room_xyz", "user_123")
      iex> Enum.each(stream, fn chunk -> IO.write(chunk.content) end)

  """
  @spec stream_response(InteractorClient.t(), String.t(), String.t()) ::
          {:ok, Enumerable.t()} | {:error, term()}
  def stream_response(%InteractorClient{} = client, room_id, namespace) do
    with {:ok, client} <- InteractorClient.ensure_valid_token(client) do
      url = "#{InteractorClient.core_url(client)}#{@api_path}/rooms/#{room_id}/messages/stream"

      headers = [
        InteractorClient.auth_header(client),
        {"X-Namespace", namespace},
        {"Accept", "text/event-stream"}
      ]

      # Note: This is a simplified implementation
      # In production, you'd use a proper SSE client library
      case Req.get(url, headers: headers, into: :self) do
        {:ok, response} ->
          {:ok, stream_events(response)}

        {:error, reason} ->
          {:error, {:request_failed, reason}}
      end
    end
  end

  # ============================================================================
  # Assistant Management
  # ============================================================================

  @doc """
  Creates a new AI assistant.

  ## Parameters

  - `client`: Authenticated InteractorClient
  - `config`: Assistant configuration map with keys:
    - `name`: Unique identifier (lowercase, underscores)
    - `title`: Display name
    - `description`: What the assistant does
    - `instructions`: System prompt defining behavior
    - `model_config`: Optional model configuration

  ## Examples

      iex> Agents.create_assistant(client, %{
      ...>   name: "project_assessor",
      ...>   title: "AI Project Assessor",
      ...>   instructions: "You are an expert AI project assessor..."
      ...> })
      {:ok, %{id: "asst_abc", name: "project_assessor", ...}}

  """
  @spec create_assistant(InteractorClient.t(), map()) :: {:ok, map()} | {:error, term()}
  def create_assistant(%InteractorClient{} = client, config) do
    with {:ok, client} <- InteractorClient.ensure_valid_token(client) do
      url = "#{InteractorClient.core_url(client)}#{@api_path}/assistants"

      body = %{
        name: config[:name] || config["name"],
        title: config[:title] || config["title"],
        description: config[:description] || config["description"],
        system_prompt: config[:instructions] || config["instructions"] || config[:system_prompt] || config["system_prompt"],
        model_config: config[:model_config] || config["model_config"] || default_model_config(),
        enabled_tools: config[:enabled_tools] || config["enabled_tools"] || []
      }

      headers = [
        InteractorClient.auth_header(client),
        {"Content-Type", "application/json"}
      ]

      Logger.info("[Interactor] Creating assistant: #{body.name}")

      case Req.post(url, json: body, headers: headers) do
        {:ok, %Req.Response{status: status, body: %{"data" => data}}} when status in [200, 201] ->
          Logger.info("[Interactor] Assistant created: #{data["id"]}")
          {:ok, parse_assistant(data)}

        {:ok, %Req.Response{status: 409, body: body}} ->
          # Conflict - assistant with this name already exists
          Logger.info("[Interactor] Assistant already exists")
          {:error, {:already_exists, body}}

        {:ok, %Req.Response{status: status, body: body}} ->
          Logger.error("[Interactor] Failed to create assistant: status=#{status}, body=#{inspect(body)}")
          {:error, {:api_error, status, body}}

        {:error, reason} ->
          Logger.error("[Interactor] Request failed: #{inspect(reason)}")
          {:error, {:request_failed, reason}}
      end
    end
  end

  @doc """
  Lists all assistants for the account.

  ## Examples

      iex> Agents.list_assistants(client)
      {:ok, [%{id: "asst_abc", name: "project_assessor", ...}]}

  """
  @spec list_assistants(InteractorClient.t()) :: {:ok, [map()]} | {:error, term()}
  def list_assistants(%InteractorClient{} = client) do
    with {:ok, client} <- InteractorClient.ensure_valid_token(client) do
      url = "#{InteractorClient.core_url(client)}#{@api_path}/assistants"

      headers = [
        InteractorClient.auth_header(client)
      ]

      case Req.get(url, headers: headers) do
        {:ok, %Req.Response{status: 200, body: %{"data" => data}}} ->
          {:ok, Enum.map(data, &parse_assistant/1)}

        {:ok, %Req.Response{status: status, body: body}} ->
          {:error, {:api_error, status, body}}

        {:error, reason} ->
          {:error, {:request_failed, reason}}
      end
    end
  end

  @doc """
  Gets an assistant by ID.

  ## Examples

      iex> Agents.get_assistant(client, "asst_abc")
      {:ok, %{id: "asst_abc", name: "project_assessor", ...}}

  """
  @spec get_assistant(InteractorClient.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get_assistant(%InteractorClient{} = client, assistant_id) do
    with {:ok, client} <- InteractorClient.ensure_valid_token(client) do
      url = "#{InteractorClient.core_url(client)}#{@api_path}/assistants/#{assistant_id}"

      headers = [
        InteractorClient.auth_header(client)
      ]

      case Req.get(url, headers: headers) do
        {:ok, %Req.Response{status: 200, body: %{"data" => data}}} ->
          {:ok, parse_assistant(data)}

        {:ok, %Req.Response{status: 404}} ->
          {:error, :not_found}

        {:ok, %Req.Response{status: status, body: body}} ->
          {:error, {:api_error, status, body}}

        {:error, reason} ->
          {:error, {:request_failed, reason}}
      end
    end
  end

  defp default_model_config do
    %{
      "provider" => "anthropic",
      "model" => "claude-sonnet-4-20250514",
      "temperature" => 0.7
    }
  end

  defp parse_assistant(data) do
    %{
      id: data["id"],
      name: data["name"],
      title: data["title"],
      description: data["description"],
      created_at: data["created_at"]
    }
  end

  # ============================================================================
  # Private Functions - Room/Message Parsing
  # ============================================================================

  defp parse_room(data) do
    %{
      id: data["id"],
      assistant_id: data["assistant_id"],
      namespace: data["namespace"],
      metadata: data["metadata"] || %{},
      created_at: data["created_at"]
    }
  end

  defp parse_message(data) do
    %{
      id: data["id"],
      room_id: data["room_id"],
      role: data["role"],
      content: data["content"],
      tool_calls: data["tool_calls"],
      created_at: data["created_at"]
    }
  end

  defp stream_events(response) do
    Stream.resource(
      fn -> response end,
      fn resp ->
        receive do
          {:data, data} ->
            case parse_sse_event(data) do
              {:ok, event} -> {[event], resp}
              :skip -> {[], resp}
              :done -> {:halt, resp}
            end
        after
          30_000 -> {:halt, resp}
        end
      end,
      fn _resp -> :ok end
    )
  end

  defp parse_sse_event(data) do
    cond do
      String.starts_with?(data, "data: [DONE]") ->
        :done

      String.starts_with?(data, "data: ") ->
        json = String.trim_leading(data, "data: ")

        case Jason.decode(json) do
          {:ok, parsed} -> {:ok, parsed}
          {:error, _} -> :skip
        end

      true ->
        :skip
    end
  end
end
