defmodule AiAgentProjectAssessor.Accounts do
  @moduledoc """
  The Accounts context.

  Handles user management and authentication-related operations.
  Users are linked to Interactor accounts via their interactor_id.
  """

  import Ecto.Query, warn: false
  alias AiAgentProjectAssessor.Repo
  alias AiAgentProjectAssessor.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Returns `nil` if the user does not exist.

  ## Examples

      iex> get_user("valid-uuid")
      %User{}

      iex> get_user("invalid-uuid")
      nil

  """
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the user does not exist.

  ## Examples

      iex> get_user!("valid-uuid")
      %User{}

      iex> get_user!("invalid-uuid")
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a user by their Interactor ID.

  Returns `nil` if no user with that Interactor ID exists.

  ## Examples

      iex> get_user_by_interactor_id("interactor-uuid")
      %User{}

      iex> get_user_by_interactor_id("unknown")
      nil

  """
  def get_user_by_interactor_id(interactor_id) do
    Repo.get_by(User, interactor_id: interactor_id)
  end

  @doc """
  Gets a user by their email.

  Returns `nil` if no user with that email exists.

  ## Examples

      iex> get_user_by_email("user@example.com")
      %User{}

      iex> get_user_by_email("unknown@example.com")
      nil

  """
  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{interactor_id: "...", email: "user@example.com"})
      {:ok, %User{}}

      iex> create_user(%{})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets or creates a user by their Interactor ID.

  Used during authentication to ensure the user exists locally.

  ## Examples

      iex> get_or_create_user(%{interactor_id: "...", email: "user@example.com"})
      {:ok, %User{}}

  """
  def get_or_create_user(%{interactor_id: interactor_id} = attrs) do
    case get_user_by_interactor_id(interactor_id) do
      nil -> create_user(attrs)
      user -> {:ok, user}
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{name: "New Name"})
      {:ok, %User{}}

      iex> update_user(user, %{email: nil})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates user preferences.

  ## Examples

      iex> update_preferences(user, %{theme: "dark"})
      {:ok, %User{}}

  """
  def update_preferences(%User{} = user, preferences) do
    user
    |> User.preferences_changeset(%{preferences: preferences})
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
