defmodule AiAgentProjectAssessor.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    # Session status enum
    execute(
      "CREATE TYPE session_status AS ENUM ('gathering', 'ready_for_report', 'report_generated', 'editing', 'exported')",
      "DROP TYPE session_status"
    )

    create table(:sessions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      add :name, :string, null: false
      add :status, :session_status, null: false, default: "gathering"

      # Interactor references
      add :workflow_instance_id, :string
      add :agent_room_id, :string

      # Progress tracking (cached from Interactor Workflow)
      add :confidence, :float, default: 0.0
      add :dimensions_complete, :integer, default: 0

      # Metadata
      add :initial_input, :text
      add :metadata, :map, default: %{}

      timestamps(type: :utc_datetime)
    end

    create index(:sessions, [:user_id])
    create index(:sessions, [:status])
    create index(:sessions, [:updated_at])
    create index(:sessions, [:workflow_instance_id])
    create index(:sessions, [:agent_room_id])
  end
end
