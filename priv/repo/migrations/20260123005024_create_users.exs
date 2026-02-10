defmodule AiAgentProjectAssessor.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :interactor_id, :string, null: false
      add :email, :string, null: false
      add :name, :string
      add :preferences, :map, default: %{}

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:interactor_id])
    create unique_index(:users, [:email])
  end
end
