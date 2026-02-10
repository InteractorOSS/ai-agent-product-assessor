defmodule AiAgentProjectAssessor.Assessments do
  @moduledoc """
  The Assessments context.

  Handles assessment session management, including creating, updating,
  and tracking progress of AI project assessments.
  """

  import Ecto.Query, warn: false
  alias AiAgentProjectAssessor.Repo
  alias AiAgentProjectAssessor.Assessments.Session

  @doc """
  Returns the list of sessions for a user.

  Sessions are ordered by most recently updated first.

  ## Examples

      iex> list_sessions(user_id)
      [%Session{}, ...]

  """
  def list_sessions(user_id) do
    Session
    |> where([s], s.user_id == ^user_id)
    |> order_by([s], desc: s.updated_at)
    |> Repo.all()
  end

  @doc """
  Returns all sessions (admin function).

  ## Examples

      iex> list_all_sessions()
      [%Session{}, ...]

  """
  def list_all_sessions do
    Session
    |> order_by([s], desc: s.updated_at)
    |> preload(:user)
    |> Repo.all()
  end

  @doc """
  Gets a single session.

  Returns `nil` if the session does not exist.

  ## Examples

      iex> get_session("valid-uuid")
      %Session{}

      iex> get_session("invalid-uuid")
      nil

  """
  def get_session(id), do: Repo.get(Session, id)

  @doc """
  Gets a single session.

  Raises `Ecto.NoResultsError` if the session does not exist.

  ## Examples

      iex> get_session!("valid-uuid")
      %Session{}

      iex> get_session!("invalid-uuid")
      ** (Ecto.NoResultsError)

  """
  def get_session!(id), do: Repo.get!(Session, id)

  @doc """
  Gets a session with preloaded associations.

  ## Examples

      iex> get_session_with_preloads("valid-uuid")
      %Session{user: %User{}, report: %Report{}}

  """
  def get_session_with_preloads(id) do
    Session
    |> where([s], s.id == ^id)
    |> preload([:user, report: :versions])
    |> Repo.one()
  end

  @doc """
  Gets a session by its Interactor workflow instance ID.

  ## Examples

      iex> get_session_by_workflow_id("workflow-instance-id")
      %Session{}

  """
  def get_session_by_workflow_id(workflow_instance_id) do
    Repo.get_by(Session, workflow_instance_id: workflow_instance_id)
  end

  @doc """
  Gets a session by its Interactor agent room ID.

  ## Examples

      iex> get_session_by_room_id("agent-room-id")
      %Session{}

  """
  def get_session_by_room_id(agent_room_id) do
    Repo.get_by(Session, agent_room_id: agent_room_id)
  end

  @doc """
  Creates a new assessment session.

  ## Examples

      iex> create_session(%{name: "My AI Project", user_id: "..."})
      {:ok, %Session{}}

      iex> create_session(%{})
      {:error, %Ecto.Changeset{}}

  """
  def create_session(attrs \\ %{}) do
    %Session{}
    |> Session.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a session.

  ## Examples

      iex> update_session(session, %{status: :ready_for_report})
      {:ok, %Session{}}

      iex> update_session(session, %{status: :invalid})
      {:error, %Ecto.Changeset{}}

  """
  def update_session(%Session{} = session, attrs) do
    session
    |> Session.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates session progress from Interactor workflow data.

  ## Examples

      iex> update_progress(session, %{confidence: 0.85, dimensions_complete: 10})
      {:ok, %Session{}}

  """
  def update_progress(%Session{} = session, attrs) do
    session
    |> Session.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Links a session to Interactor workflow and agent room.

  ## Examples

      iex> link_interactor(session, %{workflow_instance_id: "...", agent_room_id: "..."})
      {:ok, %Session{}}

  """
  def link_interactor(%Session{} = session, attrs) do
    session
    |> Session.interactor_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Transitions a session to a new status.

  ## Examples

      iex> transition_status(session, :ready_for_report)
      {:ok, %Session{}}

  """
  def transition_status(%Session{} = session, new_status) do
    update_session(session, %{status: new_status})
  end

  @doc """
  Updates session content fields (initial_input and metadata).

  Used for auto-save functionality on the Show page.

  ## Examples

      iex> update_session_content(session, %{initial_input: "Updated description"})
      {:ok, %Session{}}

  """
  def update_session_content(%Session{} = session, attrs) do
    session
    |> Session.update_changeset(Map.take(attrs, [:initial_input, :metadata]))
    |> Repo.update()
  end

  @doc """
  Deletes a session.

  ## Examples

      iex> delete_session(session)
      {:ok, %Session{}}

  """
  def delete_session(%Session{} = session) do
    Repo.delete(session)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking session changes.

  ## Examples

      iex> change_session(session)
      %Ecto.Changeset{data: %Session{}}

  """
  def change_session(%Session{} = session, attrs \\ %{}) do
    Session.update_changeset(session, attrs)
  end

  @doc """
  Lists sessions by status.

  ## Examples

      iex> list_sessions_by_status(user_id, :gathering)
      [%Session{}, ...]

  """
  def list_sessions_by_status(user_id, status) do
    Session
    |> where([s], s.user_id == ^user_id and s.status == ^status)
    |> order_by([s], desc: s.updated_at)
    |> Repo.all()
  end

  @doc """
  Lists sessions with optional filters.

  ## Options

    * `:status` - Filter by status
    * `:limit` - Maximum number of results (default: 20)
    * `:offset` - Pagination offset

  ## Examples

      iex> list_sessions_filtered(status: :gathering, limit: 10)
      [%Session{}, ...]

  """
  def list_sessions_filtered(opts \\ []) do
    limit = Keyword.get(opts, :limit, 20)
    offset = Keyword.get(opts, :offset, 0)
    status = Keyword.get(opts, :status)

    query =
      Session
      |> order_by([s], desc: s.updated_at)
      |> limit(^limit)
      |> offset(^offset)

    query =
      if status do
        where(query, [s], s.status == ^status)
      else
        query
      end

    Repo.all(query)
  end

  @doc """
  Updates Interactor IDs for a session.

  ## Examples

      iex> update_interactor_ids(session, "room-id", "workflow-id")
      {:ok, %Session{}}

  """
  def update_interactor_ids(%Session{} = session, room_id, workflow_instance_id) do
    session
    |> Session.interactor_changeset(%{
      agent_room_id: room_id,
      workflow_instance_id: workflow_instance_id
    })
    |> Repo.update()
  end

  @doc """
  Checks if a session is ready for report generation.

  A session is ready when confidence is >= 0.95 (95%).

  ## Examples

      iex> ready_for_report?(%Session{confidence: 0.96})
      true

      iex> ready_for_report?(%Session{confidence: 0.80})
      false

  """
  def ready_for_report?(%Session{confidence: confidence}) do
    confidence >= 0.95
  end

  # ============================================================================
  # Message Persistence
  # ============================================================================

  @doc """
  Appends a message to the session's message history.

  Messages are stored in session.metadata["messages"] as a list of maps.

  ## Examples

      iex> append_message(session, %{role: "user", content: "Hello", timestamp: ~U[2024-01-01 00:00:00Z]})
      {:ok, %Session{}}

  """
  def append_message(%Session{} = session, message) do
    # Fetch fresh session from DB to avoid race conditions with concurrent updates
    fresh_session = get_session(session.id)
    current_messages = get_messages(fresh_session)

    # Normalize the message to ensure consistent format
    normalized_message = %{
      "role" => to_string(message[:role] || message["role"]),
      "content" => message[:content] || message["content"],
      "timestamp" => format_timestamp(message[:timestamp] || message["timestamp"])
    }

    new_messages = current_messages ++ [normalized_message]

    updated_metadata =
      (fresh_session.metadata || %{})
      |> Map.put("messages", new_messages)

    update_session(fresh_session, %{metadata: updated_metadata})
  end

  @doc """
  Appends multiple messages to the session's message history.

  ## Examples

      iex> append_messages(session, [%{role: "user", content: "Hi"}, %{role: "assistant", content: "Hello!"}])
      {:ok, %Session{}}

  """
  def append_messages(%Session{} = session, messages) when is_list(messages) do
    # Fetch fresh session from DB to avoid race conditions with concurrent updates
    fresh_session = get_session(session.id)
    current_messages = get_messages(fresh_session)

    normalized_messages =
      Enum.map(messages, fn msg ->
        %{
          "role" => to_string(msg[:role] || msg["role"]),
          "content" => msg[:content] || msg["content"],
          "timestamp" => format_timestamp(msg[:timestamp] || msg["timestamp"])
        }
      end)

    new_messages = current_messages ++ normalized_messages

    updated_metadata =
      (fresh_session.metadata || %{})
      |> Map.put("messages", new_messages)

    update_session(fresh_session, %{metadata: updated_metadata})
  end

  @doc """
  Gets all messages from a session's metadata.

  Returns an empty list if no messages exist.

  ## Examples

      iex> get_messages(session)
      [%{"role" => "user", "content" => "Hello", "timestamp" => "..."}]

  """
  def get_messages(%Session{metadata: nil}), do: []

  def get_messages(%Session{metadata: metadata}) do
    Map.get(metadata, "messages", [])
  end

  @doc """
  Clears all messages from a session.

  ## Examples

      iex> clear_messages(session)
      {:ok, %Session{}}

  """
  def clear_messages(%Session{} = session) do
    updated_metadata =
      (session.metadata || %{})
      |> Map.delete("messages")

    update_session(session, %{metadata: updated_metadata})
  end

  defp format_timestamp(nil), do: DateTime.to_iso8601(DateTime.utc_now())
  defp format_timestamp(%DateTime{} = dt), do: DateTime.to_iso8601(dt)
  defp format_timestamp(ts) when is_binary(ts), do: ts
end
