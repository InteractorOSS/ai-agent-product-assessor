defmodule AiAgentProjectAssessor.Reports.Report do
  @moduledoc """
  Report schema representing a generated assessment report.

  Reports contain the full assessment content organized into sections,
  including the AI Suitability Score and recommendation.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @recommendations ["proceed", "proceed_with_caution", "do_not_proceed"]

  @default_section_order [
    "executive_summary",
    "problem_statement",
    "current_state",
    "ai_suitability_score",
    "success_criteria",
    "users_stakeholders",
    "failure_consequences",
    "data_availability",
    "technical_feasibility",
    "organizational_readiness",
    "budget_timeline",
    "scope_boundaries",
    "human_oversight",
    "risk_register",
    "recommendation"
  ]

  schema "reports" do
    field :content, :map, default: %{}
    field :section_order, {:array, :string}, default: @default_section_order
    field :suitability_score, :float
    field :recommendation, :string

    belongs_to :session, AiAgentProjectAssessor.Assessments.Session
    has_many :versions, AiAgentProjectAssessor.Reports.Version
    has_many :exports, AiAgentProjectAssessor.Reports.Export

    timestamps(type: :utc_datetime)
  end

  @doc """
  Changeset for creating a new report.
  """
  def create_changeset(report, attrs) do
    report
    |> cast(attrs, [:session_id, :content, :section_order, :suitability_score, :recommendation])
    |> validate_required([:session_id, :content])
    |> validate_inclusion(:recommendation, @recommendations)
    |> validate_number(:suitability_score,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 100
    )
    |> foreign_key_constraint(:session_id)
    |> unique_constraint(:session_id)
  end

  @doc """
  Changeset for updating report content.
  """
  def update_changeset(report, attrs) do
    report
    |> cast(attrs, [:content, :section_order, :suitability_score, :recommendation])
    |> validate_inclusion(:recommendation, @recommendations)
    |> validate_number(:suitability_score,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 100
    )
  end

  @doc """
  Returns the default section order for reports.
  """
  def default_section_order, do: @default_section_order

  @doc """
  Returns the valid recommendations.
  """
  def recommendations, do: @recommendations
end
