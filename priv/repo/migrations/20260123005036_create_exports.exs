defmodule AiAgentProjectAssessor.Repo.Migrations.CreateExports do
  use Ecto.Migration

  def change do
    # Export format enum
    execute(
      "CREATE TYPE export_format AS ENUM ('pdf', 'docx', 'markdown', 'html')",
      "DROP TYPE export_format"
    )

    create table(:exports, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :report_id, references(:reports, type: :binary_id, on_delete: :delete_all), null: false

      add :format, :export_format, null: false
      add :file_path, :string, null: false
      # in bytes
      add :file_size, :integer

      # Export metadata
      add :generated_by, references(:users, type: :binary_id, on_delete: :nilify_all)
      add :version_id, references(:versions, type: :binary_id, on_delete: :nilify_all)

      timestamps(type: :utc_datetime)
    end

    create index(:exports, [:report_id])
    create index(:exports, [:format])
    create index(:exports, [:inserted_at])
  end
end
