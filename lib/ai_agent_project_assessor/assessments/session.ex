defmodule AiAgentProjectAssessor.Assessments.Session do
  @moduledoc """
  Session schema representing an assessment session.

  Sessions track the progress of an AI project assessment and link to
  Interactor Workflow instances and Agent rooms for state management.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @statuses [:gathering, :ready_for_report, :report_generated, :editing, :exported]

  schema "sessions" do
    field :name, :string
    field :status, Ecto.Enum, values: @statuses, default: :gathering

    # Interactor references
    field :workflow_instance_id, :string
    field :agent_room_id, :string

    # Progress tracking (cached from Interactor Workflow)
    field :confidence, :float, default: 0.0
    field :dimensions_complete, :integer, default: 0

    # Metadata
    field :initial_input, :string
    field :metadata, :map, default: %{}

    belongs_to :user, AiAgentProjectAssessor.Accounts.User
    has_one :report, AiAgentProjectAssessor.Reports.Report

    timestamps(type: :utc_datetime)
  end

  @doc """
  Changeset for creating a new session.
  """
  def create_changeset(session, attrs) do
    session
    |> cast(attrs, [:name, :user_id, :initial_input, :metadata])
    |> validate_required([:name, :user_id])
    |> validate_length(:name, min: 1, max: 255)
    |> foreign_key_constraint(:user_id)
  end

  @doc """
  Changeset for updating session status and progress.
  """
  def update_changeset(session, attrs) do
    session
    |> cast(attrs, [
      :name,
      :status,
      :workflow_instance_id,
      :agent_room_id,
      :confidence,
      :dimensions_complete,
      :initial_input,
      :metadata
    ])
    |> validate_inclusion(:status, @statuses)
    |> validate_number(:confidence, greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0)
    |> validate_number(:dimensions_complete,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 12
    )
  end

  @doc """
  Changeset for linking Interactor references.
  """
  def interactor_changeset(session, attrs) do
    session
    |> cast(attrs, [:workflow_instance_id, :agent_room_id])
  end

  @doc """
  Returns the list of valid session statuses.
  """
  def statuses, do: @statuses
end
