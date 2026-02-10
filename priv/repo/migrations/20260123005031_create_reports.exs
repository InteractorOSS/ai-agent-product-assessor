defmodule AiAgentProjectAssessor.Repo.Migrations.CreateReports do
  use Ecto.Migration

  def change do
    create table(:reports, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :session_id, references(:sessions, type: :binary_id, on_delete: :delete_all),
        null: false

      # Report content as JSONB - stores all sections
      # Structure: %{
      #   "executive_summary" => "...",
      #   "problem_statement" => "...",
      #   "ai_suitability_score" => %{...},
      #   ... (13 sections total)
      # }
      add :content, :map, null: false, default: %{}

      # Section ordering for drag-and-drop reorder
      add :section_order, {:array, :string}, default: []

      # AI Suitability Score summary
      add :suitability_score, :float
      # "proceed", "proceed_with_caution", "do_not_proceed"
      add :recommendation, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:reports, [:session_id])
    create index(:reports, [:suitability_score])
  end
end
