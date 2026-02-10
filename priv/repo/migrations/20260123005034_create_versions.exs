defmodule AiAgentProjectAssessor.Repo.Migrations.CreateVersions do
  use Ecto.Migration

  def change do
    create table(:versions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :report_id, references(:reports, type: :binary_id, on_delete: :delete_all), null: false

      # Snapshot of report content at this version
      add :content, :map, null: false
      add :section_order, {:array, :string}, default: []

      # Version metadata
      add :description, :string
      add :version_number, :integer, null: false

      # What changed (for display in history)
      add :change_summary, :string

      timestamps(type: :utc_datetime)
    end

    create index(:versions, [:report_id])
    create index(:versions, [:report_id, :version_number])
    create index(:versions, [:inserted_at])
  end
end
