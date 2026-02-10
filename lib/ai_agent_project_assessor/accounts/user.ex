defmodule AiAgentProjectAssessor.Accounts.User do
  @moduledoc """
  User schema representing authenticated users.

  Users are linked to their Interactor account via `interactor_id`.
  Local storage handles user preferences and provides fast lookups.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "users" do
    field :interactor_id, :string
    field :email, :string
    field :name, :string
    field :preferences, :map, default: %{}

    has_many :sessions, AiAgentProjectAssessor.Assessments.Session

    timestamps(type: :utc_datetime)
  end

  @doc """
  Changeset for creating or updating a user.
  """
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:interactor_id, :email, :name, :preferences])
    |> validate_required([:interactor_id, :email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must be a valid email")
    |> unique_constraint(:interactor_id)
    |> unique_constraint(:email)
  end

  @doc """
  Changeset for updating user preferences.
  """
  def preferences_changeset(user, attrs) do
    user
    |> cast(attrs, [:preferences])
  end
end
