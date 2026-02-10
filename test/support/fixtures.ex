defmodule AiAgentProjectAssessor.Fixtures do
  @moduledoc """
  Test fixtures for creating test data.
  """

  alias AiAgentProjectAssessor.Repo
  alias AiAgentProjectAssessor.Accounts.User
  alias AiAgentProjectAssessor.Assessments.Session
  alias AiAgentProjectAssessor.Reports.Report

  @doc """
  Creates a user with the given attributes.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        interactor_id: "interactor_#{unique_id()}",
        email: "user#{unique_id()}@example.com",
        name: "Test User",
        preferences: %{}
      })
      |> then(&User.changeset(%User{}, &1))
      |> Repo.insert()

    user
  end

  @doc """
  Creates an assessment session for a user.
  """
  def session_fixture(user, attrs \\ %{}) do
    {:ok, session} =
      attrs
      |> Enum.into(%{
        user_id: user.id,
        name: "Test Assessment #{unique_id()}",
        status: :gathering,
        initial_input: "Test project idea"
      })
      |> then(&Session.create_changeset(%Session{}, &1))
      |> Repo.insert()

    session
  end

  @doc """
  Creates a report for a session.
  """
  def report_fixture(session, attrs \\ %{}) do
    default_content = %{
      "executive_summary" => "This is a test summary.",
      "problem_statement" => "Test problem statement.",
      "proposed_solution" => "Test solution.",
      "technical_feasibility" => "Technical analysis here.",
      "resource_requirements" => "Resource details.",
      "risk_assessment" => "Risk analysis.",
      "implementation_roadmap" => "Implementation plan.",
      "success_criteria" => "Success metrics.",
      "recommendations" => "Final recommendations."
    }

    {:ok, report} =
      attrs
      |> Enum.into(%{
        session_id: session.id,
        content: default_content,
        section_order: Map.keys(default_content),
        suitability_score: 75.0,
        status: :draft
      })
      |> then(&Report.create_changeset(%Report{}, &1))
      |> Repo.insert()

    report
  end

  @doc """
  Creates a complete assessment with optional report.
  Messages are handled via Interactor agent rooms, not stored locally.
  """
  def complete_assessment_fixture(user, opts \\ []) do
    session = session_fixture(user, Keyword.get(opts, :session_attrs, %{}))

    report =
      if Keyword.get(opts, :with_report, false) do
        report_fixture(session)
      else
        nil
      end

    {session, report}
  end

  defp unique_id do
    System.unique_integer([:positive])
  end
end
