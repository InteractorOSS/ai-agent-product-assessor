defmodule AiAgentProjectAssessor.Reports.Version do
  @moduledoc """
  Version schema for tracking report edit history.

  Each version captures a snapshot of the report content at a point in time,
  enabling version history and restore functionality.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "versions" do
    field :content, :map
    field :section_order, {:array, :string}, default: []
    field :description, :string
    field :version_number, :integer
    field :change_summary, :string

    belongs_to :report, AiAgentProjectAssessor.Reports.Report

    timestamps(type: :utc_datetime)
  end

  @doc """
  Changeset for creating a new version snapshot.
  """
  def create_changeset(version, attrs) do
    version
    |> cast(attrs, [
      :report_id,
      :content,
      :section_order,
      :description,
      :version_number,
      :change_summary
    ])
    |> validate_required([:report_id, :content, :version_number])
    |> validate_number(:version_number, greater_than: 0)
    |> foreign_key_constraint(:report_id)
  end
end
