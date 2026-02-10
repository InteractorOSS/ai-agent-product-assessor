defmodule AiAgentProjectAssessor.ReportGeneratorTest do
  use AiAgentProjectAssessor.DataCase, async: true

  alias AiAgentProjectAssessor.ReportGenerator
  alias AiAgentProjectAssessor.Assessments
  alias AiAgentProjectAssessor.Accounts

  describe "sections/0" do
    test "returns all 15 report sections" do
      sections = ReportGenerator.sections()

      assert is_list(sections)
      assert length(sections) == 15

      expected_sections = [
        "executive_summary",
        "project_overview",
        "problem_statement",
        "proposed_solution",
        "data_assessment",
        "technical_feasibility",
        "integration_requirements",
        "success_criteria",
        "user_requirements",
        "constraints_assumptions",
        "risk_register",
        "timeline_milestones",
        "budget_estimates",
        "ai_suitability_score",
        "recommendations"
      ]

      assert sections == expected_sections
    end
  end

  describe "section_title/1" do
    test "returns correct titles for all sections" do
      assert ReportGenerator.section_title("executive_summary") == "Executive Summary"
      assert ReportGenerator.section_title("project_overview") == "Project Overview"
      assert ReportGenerator.section_title("problem_statement") == "Problem Statement"
      assert ReportGenerator.section_title("proposed_solution") == "Proposed Solution"
      assert ReportGenerator.section_title("data_assessment") == "Data Assessment"
      assert ReportGenerator.section_title("technical_feasibility") == "Technical Feasibility"

      assert ReportGenerator.section_title("integration_requirements") ==
               "Integration Requirements"

      assert ReportGenerator.section_title("success_criteria") == "Success Criteria"
      assert ReportGenerator.section_title("user_requirements") == "User Requirements"

      assert ReportGenerator.section_title("constraints_assumptions") ==
               "Constraints & Assumptions"

      assert ReportGenerator.section_title("risk_register") == "Risk Register"
      assert ReportGenerator.section_title("timeline_milestones") == "Timeline & Milestones"
      assert ReportGenerator.section_title("budget_estimates") == "Budget Estimates"
      assert ReportGenerator.section_title("ai_suitability_score") == "AI Suitability Score"
      assert ReportGenerator.section_title("recommendations") == "Recommendations"
    end

    test "humanizes unknown section names" do
      assert ReportGenerator.section_title("my_custom_section") == "My Custom Section"
      assert ReportGenerator.section_title("another_test") == "Another Test"
    end
  end

  describe "generate/2" do
    setup do
      # Create a user for all generate tests
      {:ok, user} =
        Accounts.create_user(%{
          interactor_id: "test-interactor-#{System.unique_integer([:positive])}",
          email: "test-#{System.unique_integer([:positive])}@example.com",
          name: "Test User"
        })

      %{user: user}
    end

    test "generates a complete report with all sections", %{user: user} do
      {:ok, session} =
        Assessments.create_session(%{
          name: "Test AI Project",
          user_id: user.id,
          initial_input: "A test project for AI agent assessment",
          status: :ready_for_report
        })

      assessment_data = sample_assessment_data()

      {:ok, report} = ReportGenerator.generate(session, assessment_data)

      assert report.content != nil
      assert is_map(report.content)
      assert report.session_id == session.id

      # Check all sections are present
      for section <- ReportGenerator.sections() do
        assert Map.has_key?(report.content, section),
               "Missing section: #{section}"

        assert is_binary(report.content[section]),
               "Section #{section} should be a string"

        assert String.length(report.content[section]) > 0,
               "Section #{section} should not be empty"
      end
    end

    test "calculates suitability score", %{user: user} do
      {:ok, session} =
        Assessments.create_session(%{
          name: "Score Test Project",
          user_id: user.id,
          status: :ready_for_report
        })

      assessment_data = sample_assessment_data()

      {:ok, report} = ReportGenerator.generate(session, assessment_data)

      assert report.suitability_score != nil
      assert is_number(report.suitability_score)
      assert report.suitability_score >= 0
      assert report.suitability_score <= 100
    end

    test "sets section order", %{user: user} do
      {:ok, session} =
        Assessments.create_session(%{
          name: "Order Test Project",
          user_id: user.id,
          status: :ready_for_report
        })

      assessment_data = sample_assessment_data()

      {:ok, report} = ReportGenerator.generate(session, assessment_data)

      assert report.section_order != nil
      assert is_list(report.section_order)
      assert length(report.section_order) == 15
      assert report.section_order == ReportGenerator.sections()
    end

    test "determines recommendation based on score", %{user: user} do
      {:ok, session} =
        Assessments.create_session(%{
          name: "Recommendation Test",
          user_id: user.id,
          status: :ready_for_report
        })

      # High confidence should result in "proceed" recommendation
      high_confidence_data = %{
        dimensions_data: %{
          "problem_statement" => %{confidence: 0.95, data: "Clear problem"},
          "solution_approach" => %{confidence: 0.90, data: "Clear solution"},
          "data_availability" => %{confidence: 0.90, data: "Good data"},
          "data_quality" => %{confidence: 0.85, data: "Quality data"},
          "technical_feasibility" => %{confidence: 0.88, data: "Feasible"}
        },
        confidence: 0.90
      }

      {:ok, report} = ReportGenerator.generate(session, high_confidence_data)

      # High confidence should result in high score and "proceed" recommendation
      assert report.suitability_score >= 75
      assert report.recommendation == "proceed"
    end

    test "recommends caution for moderate confidence", %{user: user} do
      {:ok, session} =
        Assessments.create_session(%{
          name: "Caution Test",
          user_id: user.id,
          status: :ready_for_report
        })

      moderate_data = %{
        dimensions_data: %{
          "problem_statement" => %{confidence: 0.65, data: "Some clarity"},
          "solution_approach" => %{confidence: 0.60, data: "Some approach"},
          "data_availability" => %{confidence: 0.55, data: "Limited data"},
          "data_quality" => %{confidence: 0.50, data: "Moderate quality"},
          "technical_feasibility" => %{confidence: 0.60, data: "Uncertain"}
        },
        confidence: 0.58
      }

      {:ok, report} = ReportGenerator.generate(session, moderate_data)

      assert report.suitability_score >= 50
      assert report.suitability_score < 75
      assert report.recommendation == "proceed_with_caution"
    end

    test "recommends not proceeding for low confidence", %{user: user} do
      {:ok, session} =
        Assessments.create_session(%{
          name: "Low Confidence Test",
          user_id: user.id,
          status: :ready_for_report
        })

      low_data = %{
        dimensions_data: %{
          "problem_statement" => %{confidence: 0.30, data: "Unclear"},
          "data_availability" => %{confidence: 0.25, data: "No data"}
        },
        confidence: 0.28
      }

      {:ok, report} = ReportGenerator.generate(session, low_data)

      assert report.suitability_score < 50
      assert report.recommendation == "do_not_proceed"
    end

    test "includes session information in project overview section", %{user: user} do
      {:ok, session} =
        Assessments.create_session(%{
          name: "Project Info Test",
          user_id: user.id,
          initial_input: "This is the initial project description",
          status: :ready_for_report
        })

      {:ok, report} =
        ReportGenerator.generate(session, %{dimensions_data: %{}, confidence: 0.5})

      project_overview = report.content["project_overview"]

      assert String.contains?(project_overview, "Project Info Test")
      assert String.contains?(project_overview, "This is the initial project description")
    end

    test "handles empty dimensions gracefully", %{user: user} do
      {:ok, session} =
        Assessments.create_session(%{
          name: "Empty Test",
          user_id: user.id,
          status: :ready_for_report
        })

      empty_data = %{dimensions_data: %{}, confidence: 0}

      {:ok, report} = ReportGenerator.generate(session, empty_data)

      assert report.suitability_score == 0.0
      assert report.recommendation == "do_not_proceed"

      # All sections should still be generated
      for section <- ReportGenerator.sections() do
        assert Map.has_key?(report.content, section)
      end
    end
  end

  # Helper function for sample data
  defp sample_assessment_data do
    %{
      dimensions_data: %{
        "problem_statement" => %{
          confidence: 0.85,
          data: "Automate customer support using AI"
        },
        "solution_approach" => %{
          confidence: 0.80,
          data: "Use NLP and machine learning"
        },
        "data_availability" => %{
          confidence: 0.75,
          data: "CRM database, chat logs, email archives"
        },
        "data_quality" => %{
          confidence: 0.70,
          data: "Good quality with some cleaning needed"
        },
        "technical_feasibility" => %{
          confidence: 0.82,
          data: "Elixir/Phoenix with Python ML services"
        },
        "integration_requirements" => %{
          confidence: 0.70,
          data: "Salesforce, Zendesk integration needed"
        },
        "success_criteria" => %{
          confidence: 0.80,
          data: "Response time < 2s, satisfaction > 90%"
        },
        "user_requirements" => %{
          confidence: 0.78,
          data: "Support agents and end customers"
        },
        "constraints" => %{
          confidence: 0.80,
          data: "GDPR compliance, 1000 concurrent users"
        },
        "risk_factors" => %{
          confidence: 0.75,
          data: "Data quality, API limits, user adoption"
        },
        "timeline" => %{
          confidence: 0.72,
          data: "14 weeks total, Q2 2026 deadline"
        },
        "budget" => %{
          confidence: 0.65,
          data: "$150,000 total budget"
        }
      },
      confidence: 0.76
    }
  end
end
