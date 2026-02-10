defmodule AiAgentProjectAssessor.Reports.Export do
  @moduledoc """
  Export schema for tracking exported report files.

  Tracks all exports generated from reports, including format,
  file location, and which version was exported.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @formats [:pdf, :docx, :markdown, :html]

  schema "exports" do
    field :format, Ecto.Enum, values: @formats
    field :file_path, :string
    field :file_size, :integer

    belongs_to :report, AiAgentProjectAssessor.Reports.Report

    belongs_to :generated_by_user, AiAgentProjectAssessor.Accounts.User,
      foreign_key: :generated_by

    belongs_to :version, AiAgentProjectAssessor.Reports.Version

    timestamps(type: :utc_datetime)
  end

  @doc """
  Changeset for creating a new export record.
  """
  def create_changeset(export, attrs) do
    export
    |> cast(attrs, [:report_id, :format, :file_path, :file_size, :generated_by, :version_id])
    |> validate_required([:report_id, :format, :file_path])
    |> validate_inclusion(:format, @formats)
    |> validate_number(:file_size, greater_than_or_equal_to: 0)
    |> foreign_key_constraint(:report_id)
    |> foreign_key_constraint(:generated_by)
    |> foreign_key_constraint(:version_id)
  end

  @doc """
  Returns the list of valid export formats.
  """
  def formats, do: @formats
end
