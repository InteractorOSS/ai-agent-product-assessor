defmodule AiAgentProjectAssessor.ReportGenerator do
  @moduledoc """
  Generates comprehensive AI project assessment reports.

  Creates structured report content from assessment data including:
  - Executive summary with key findings
  - Problem and solution analysis
  - Data assessment
  - Technical feasibility evaluation
  - Risk register
  - Budget and timeline estimates
  - AI suitability scoring

  ## Report Sections

  1. Executive Summary
  2. Project Overview
  3. Problem Statement
  4. Proposed Solution
  5. Data Assessment
  6. Technical Feasibility
  7. Integration Requirements
  8. Success Criteria
  9. User Requirements
  10. Constraints & Assumptions
  11. Risk Register
  12. Timeline & Milestones
  13. Budget Estimates
  14. AI Suitability Score
  15. Recommendations

  ## Usage

      {:ok, report} = ReportGenerator.generate(session, assessment_data)

  """

  require Logger

  alias AiAgentProjectAssessor.Reports
  alias AiAgentProjectAssessor.Assessments

  @sections [
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

  @dimension_weights %{
    "problem_statement" => 1.2,
    "solution_approach" => 1.2,
    "data_availability" => 1.5,
    "data_quality" => 1.3,
    "technical_feasibility" => 1.4,
    "integration_requirements" => 1.0,
    "success_criteria" => 1.1,
    "user_requirements" => 1.0,
    "constraints" => 0.8,
    "risk_factors" => 1.1,
    "timeline" => 0.7,
    "budget" => 0.7
  }

  @doc """
  Generates a full report for the given session and assessment data.
  """
  @spec generate(Assessments.Session.t(), map()) :: {:ok, Reports.Report.t()} | {:error, term()}
  def generate(session, assessment_data) do
    Logger.info("Generating report for session #{session.id}")

    content = build_all_sections(session, assessment_data)
    suitability_score = calculate_suitability_score(assessment_data)
    recommendation = determine_recommendation(suitability_score)

    Reports.create_report(%{
      session_id: session.id,
      content: content,
      section_order: @sections,
      suitability_score: suitability_score,
      recommendation: recommendation
    })
  end

  @doc """
  Regenerates a specific section of an existing report.
  """
  @spec regenerate_section(Reports.Report.t(), String.t(), map()) ::
          {:ok, Reports.Report.t()} | {:error, term()}
  def regenerate_section(report, section_key, assessment_data) do
    session = Assessments.get_session!(report.session_id)
    new_content = generate_section(section_key, session, assessment_data)

    Reports.update_section(report, section_key, new_content)
  end

  @doc """
  Returns the list of report sections.
  """
  def sections, do: @sections

  @doc """
  Returns a human-readable section title.
  """
  def section_title(key) do
    titles = %{
      "executive_summary" => "Executive Summary",
      "project_overview" => "Project Overview",
      "problem_statement" => "Problem Statement",
      "proposed_solution" => "Proposed Solution",
      "data_assessment" => "Data Assessment",
      "technical_feasibility" => "Technical Feasibility",
      "integration_requirements" => "Integration Requirements",
      "success_criteria" => "Success Criteria",
      "user_requirements" => "User Requirements",
      "constraints_assumptions" => "Constraints & Assumptions",
      "risk_register" => "Risk Register",
      "timeline_milestones" => "Timeline & Milestones",
      "budget_estimates" => "Budget Estimates",
      "ai_suitability_score" => "AI Suitability Score",
      "recommendations" => "Recommendations"
    }

    Map.get(titles, key, humanize(key))
  end

  # ============================================================================
  # Private - Section Generation
  # ============================================================================

  defp build_all_sections(session, data) do
    @sections
    |> Enum.map(fn section -> {section, generate_section(section, session, data)} end)
    |> Enum.into(%{})
  end

  defp generate_section("executive_summary", session, data) do
    score = calculate_suitability_score(data)
    recommendation = determine_recommendation(score)
    dimensions = data[:dimensions_data] || %{}

    high_confidence =
      dimensions
      |> Enum.filter(fn {_, d} -> (d[:confidence] || 0) >= 0.8 end)
      |> Enum.map(fn {k, _} -> humanize(k) end)

    low_confidence =
      dimensions
      |> Enum.filter(fn {_, d} -> (d[:confidence] || 0) < 0.6 end)
      |> Enum.map(fn {k, _} -> humanize(k) end)

    """
    ## Executive Summary

    This assessment evaluates the feasibility of implementing AI/ML solutions for **#{session.name}**.

    ### Key Findings

    **Overall AI Suitability Score: #{round(score)}%**

    **Recommendation: #{format_recommendation(recommendation)}**

    #{if length(high_confidence) > 0 do
      "**Strengths:**\n#{Enum.map_join(high_confidence, "\n", &"- #{&1}")}"
    else
      ""
    end}

    #{if length(low_confidence) > 0 do
      "**Areas Requiring Attention:**\n#{Enum.map_join(low_confidence, "\n", &"- #{&1}")}"
    else
      ""
    end}

    ### Assessment Summary

    The assessment covered #{map_size(dimensions)} key dimensions with an overall confidence level of #{round((data[:confidence] || 0) * 100)}%. #{assessment_summary_text(score)}
    """
  end

  defp generate_section("project_overview", session, _data) do
    """
    ## Project Overview

    ### Project Name
    #{session.name}

    ### Initial Description
    #{session.initial_input || "No initial description provided."}

    ### Assessment Date
    #{format_date(session.inserted_at)}

    ### Current Status
    #{format_status(session.status)}
    """
  end

  defp generate_section("problem_statement", _session, data) do
    dim_data = get_dimension_data(data, "problem_statement")

    """
    ## Problem Statement

    ### Business Problem
    #{dim_data[:data] || "The business problem has been identified during the assessment process."}

    ### Impact Analysis
    Understanding the scope and impact of the problem is crucial for determining AI solution viability.

    **Confidence Level:** #{format_confidence(dim_data[:confidence])}

    ### Key Questions Addressed
    - What specific business challenge needs to be solved?
    - Who is affected by this problem?
    - What is the current business impact?
    - How is the problem currently being addressed?
    """
  end

  defp generate_section("proposed_solution", _session, data) do
    dim_data = get_dimension_data(data, "solution_approach")

    """
    ## Proposed Solution

    ### Solution Overview
    #{dim_data[:data] || "An AI-powered solution approach has been outlined during the assessment."}

    ### AI/ML Approach
    The proposed solution leverages artificial intelligence and machine learning technologies to address the identified business problem.

    **Confidence Level:** #{format_confidence(dim_data[:confidence])}

    ### Solution Components
    - Data processing and preparation
    - Model training and validation
    - Integration with existing systems
    - User interface and experience
    - Monitoring and maintenance
    """
  end

  defp generate_section("data_assessment", _session, data) do
    availability = get_dimension_data(data, "data_availability")
    quality = get_dimension_data(data, "data_quality")

    avg_confidence = ((availability[:confidence] || 0) + (quality[:confidence] || 0)) / 2

    """
    ## Data Assessment

    ### Data Availability
    #{availability[:data] || "Data availability has been evaluated as part of the assessment."}

    **Confidence Level:** #{format_confidence(availability[:confidence])}

    ### Data Quality
    #{quality[:data] || "Data quality factors have been assessed."}

    **Confidence Level:** #{format_confidence(quality[:confidence])}

    ### Overall Data Readiness
    **Score: #{round(avg_confidence * 100)}%**

    ### Key Data Considerations
    - Volume: Is there sufficient data for model training?
    - Variety: Does the data cover necessary scenarios?
    - Velocity: How frequently is new data generated?
    - Veracity: How reliable and accurate is the data?
    - Value: Does the data contain the signals needed for predictions?
    """
  end

  defp generate_section("technical_feasibility", _session, data) do
    dim_data = get_dimension_data(data, "technical_feasibility")

    """
    ## Technical Feasibility

    ### Technical Assessment
    #{dim_data[:data] || "Technical feasibility has been evaluated based on provided information."}

    **Confidence Level:** #{format_confidence(dim_data[:confidence])}

    ### Infrastructure Requirements
    - Compute resources for model training
    - Storage for data and model artifacts
    - Network infrastructure for data transfer
    - Security and compliance infrastructure

    ### Technical Considerations
    - Current technology stack compatibility
    - Team expertise and skill gaps
    - Third-party dependencies
    - Scalability requirements
    """
  end

  defp generate_section("integration_requirements", _session, data) do
    dim_data = get_dimension_data(data, "integration_requirements")

    """
    ## Integration Requirements

    ### Integration Overview
    #{dim_data[:data] || "Integration requirements have been identified during the assessment."}

    **Confidence Level:** #{format_confidence(dim_data[:confidence])}

    ### System Integrations
    - API requirements and specifications
    - Data pipeline connections
    - Authentication and authorization
    - Monitoring and logging integration

    ### Integration Complexity
    Based on the assessment, integration complexity should be factored into project planning.
    """
  end

  defp generate_section("success_criteria", _session, data) do
    dim_data = get_dimension_data(data, "success_criteria")

    """
    ## Success Criteria

    ### Defined Success Metrics
    #{dim_data[:data] || "Success criteria have been outlined for this project."}

    **Confidence Level:** #{format_confidence(dim_data[:confidence])}

    ### Key Performance Indicators (KPIs)
    - Model accuracy and performance metrics
    - Business impact measurements
    - User adoption and satisfaction
    - Operational efficiency gains

    ### Success Measurement Approach
    Regular monitoring and evaluation will be essential to track progress against defined criteria.
    """
  end

  defp generate_section("user_requirements", _session, data) do
    dim_data = get_dimension_data(data, "user_requirements")

    """
    ## User Requirements

    ### User Needs Analysis
    #{dim_data[:data] || "User requirements have been gathered as part of the assessment."}

    **Confidence Level:** #{format_confidence(dim_data[:confidence])}

    ### User Experience Considerations
    - Interface design and usability
    - Training and onboarding needs
    - Accessibility requirements
    - Feedback and iteration process
    """
  end

  defp generate_section("constraints_assumptions", _session, data) do
    dim_data = get_dimension_data(data, "constraints")

    """
    ## Constraints & Assumptions

    ### Identified Constraints
    #{dim_data[:data] || "Constraints have been documented during the assessment."}

    **Confidence Level:** #{format_confidence(dim_data[:confidence])}

    ### Project Constraints
    - Budget limitations
    - Timeline restrictions
    - Resource availability
    - Regulatory requirements
    - Technical limitations

    ### Key Assumptions
    - Data availability and quality assumptions
    - Resource allocation assumptions
    - Technology stability assumptions
    - Stakeholder engagement assumptions
    """
  end

  defp generate_section("risk_register", _session, data) do
    dim_data = get_dimension_data(data, "risk_factors")

    """
    ## Risk Register

    ### Risk Assessment Overview
    #{dim_data[:data] || "Risks have been identified and assessed."}

    **Confidence Level:** #{format_confidence(dim_data[:confidence])}

    ### Risk Categories

    #### Technical Risks
    - Model performance may not meet expectations
    - Data quality issues may impact results
    - Integration complexity may cause delays

    #### Business Risks
    - Stakeholder alignment challenges
    - Change management resistance
    - Budget overruns

    #### Operational Risks
    - Resource availability
    - Skill gaps in team
    - Vendor dependencies

    ### Risk Mitigation Strategies
    Each identified risk should have a documented mitigation strategy and owner.
    """
  end

  defp generate_section("timeline_milestones", _session, data) do
    dim_data = get_dimension_data(data, "timeline")

    """
    ## Timeline & Milestones

    ### Project Timeline
    #{dim_data[:data] || "Timeline expectations have been discussed during the assessment."}

    **Confidence Level:** #{format_confidence(dim_data[:confidence])}

    ### Suggested Project Phases

    #### Phase 1: Discovery & Planning (2-4 weeks)
    - Detailed requirements gathering
    - Data audit and preparation planning
    - Architecture design

    #### Phase 2: Development (6-12 weeks)
    - Data pipeline development
    - Model development and training
    - Integration development

    #### Phase 3: Testing & Validation (2-4 weeks)
    - Model validation
    - Integration testing
    - User acceptance testing

    #### Phase 4: Deployment & Monitoring (2-4 weeks)
    - Production deployment
    - Monitoring setup
    - Documentation and training
    """
  end

  defp generate_section("budget_estimates", _session, data) do
    dim_data = get_dimension_data(data, "budget")

    """
    ## Budget Estimates

    ### Budget Overview
    #{dim_data[:data] || "Budget considerations have been assessed."}

    **Confidence Level:** #{format_confidence(dim_data[:confidence])}

    ### Cost Categories

    #### Development Costs
    - Personnel (data scientists, engineers, PM)
    - Infrastructure (cloud compute, storage)
    - Tools and licenses

    #### Operational Costs
    - Ongoing infrastructure
    - Maintenance and support
    - Model retraining

    #### Contingency
    A 15-20% contingency is recommended for AI/ML projects due to inherent uncertainty.

    ### ROI Considerations
    Return on investment should be calculated based on defined success criteria and business impact measurements.
    """
  end

  defp generate_section("ai_suitability_score", _session, data) do
    score = calculate_suitability_score(data)
    dimensions = data[:dimensions_data] || %{}

    dimension_scores =
      dimensions
      |> Enum.map(fn {dim, d} ->
        "| #{humanize(dim)} | #{round((d[:confidence] || 0) * 100)}% |"
      end)
      |> Enum.join("\n")

    """
    ## AI Suitability Score

    ### Overall Score: #{round(score)}%

    #{score_interpretation(score)}

    ### Dimension Breakdown

    | Dimension | Score |
    |-----------|-------|
    #{dimension_scores}

    ### Scoring Methodology
    The AI Suitability Score is calculated using a weighted average of all assessment dimensions, with higher weights assigned to critical factors like data availability, technical feasibility, and problem clarity.
    """
  end

  defp generate_section("recommendations", _session, data) do
    score = calculate_suitability_score(data)
    recommendation = determine_recommendation(score)
    dimensions = data[:dimensions_data] || %{}

    low_dims =
      dimensions
      |> Enum.filter(fn {_, d} -> (d[:confidence] || 0) < 0.7 end)
      |> Enum.map(fn {k, _} -> k end)

    improvement_actions =
      low_dims
      |> Enum.map(&improvement_action/1)
      |> Enum.join("\n")

    """
    ## Recommendations

    ### Overall Recommendation
    **#{format_recommendation(recommendation)}**

    #{recommendation_detail(recommendation)}

    ### Suggested Next Steps

    #{if recommendation in ["proceed", "proceed_with_caution"] do
      """
      1. **Finalize Requirements**: Complete detailed requirements documentation
      2. **Data Preparation**: Begin data audit and preparation activities
      3. **Team Assembly**: Ensure necessary expertise is available
      4. **Pilot Planning**: Design a focused pilot to validate approach
      5. **Stakeholder Alignment**: Secure buy-in from key stakeholders
      """
    else
      """
      1. **Address Gaps**: Focus on improving low-confidence areas before proceeding
      2. **Additional Discovery**: Gather more information in uncertain areas
      3. **Stakeholder Review**: Discuss findings with key stakeholders
      4. **Re-assessment**: Schedule follow-up assessment after improvements
      """
    end}

    #{if length(low_dims) > 0 do
      """
      ### Areas Requiring Attention

      #{improvement_actions}
      """
    else
      ""
    end}

    ### Conclusion
    #{conclusion_text(score, recommendation)}
    """
  end

  defp generate_section(unknown, _session, _data) do
    """
    ## #{humanize(unknown)}

    Content for this section will be added.
    """
  end

  # ============================================================================
  # Private - Scoring & Recommendations
  # ============================================================================

  defp calculate_suitability_score(data) do
    dimensions = data[:dimensions_data] || %{}

    {weighted_sum, total_weight} =
      dimensions
      |> Enum.reduce({0.0, 0.0}, fn {dim, d}, {sum, weight} ->
        w = Map.get(@dimension_weights, dim, 1.0)
        conf = d[:confidence] || 0.0
        {sum + conf * w, weight + w}
      end)

    if total_weight > 0 do
      weighted_sum / total_weight * 100
    else
      0.0
    end
  end

  defp determine_recommendation(score) do
    cond do
      score >= 75 -> "proceed"
      score >= 50 -> "proceed_with_caution"
      true -> "do_not_proceed"
    end
  end

  defp format_recommendation(rec) do
    case rec do
      "proceed" -> "Proceed with Implementation"
      "proceed_with_caution" -> "Proceed with Caution"
      "do_not_proceed" -> "Do Not Proceed - Address Concerns First"
      _ -> rec
    end
  end

  defp score_interpretation(score) do
    cond do
      score >= 85 ->
        "**Excellent** - This project shows strong potential for successful AI implementation."

      score >= 75 ->
        "**Good** - This project is well-suited for AI, with some areas for improvement."

      score >= 60 ->
        "**Moderate** - This project has potential but requires attention in several areas."

      score >= 50 ->
        "**Marginal** - Significant improvements needed before proceeding with AI implementation."

      true ->
        "**Low** - Major concerns exist that should be addressed before considering AI solutions."
    end
  end

  defp recommendation_detail(rec) do
    case rec do
      "proceed" ->
        "Based on the assessment, this project demonstrates strong fundamentals for AI implementation. The data requirements, technical feasibility, and business case are well-defined."

      "proceed_with_caution" ->
        "This project shows promise but has areas that need attention. A phased approach with early validation checkpoints is recommended."

      "do_not_proceed" ->
        "The assessment has identified significant gaps that should be addressed before proceeding. Focus on improving the areas with low confidence scores."
    end
  end

  defp conclusion_text(score, recommendation) do
    case recommendation do
      "proceed" ->
        "With a suitability score of #{round(score)}%, this project is recommended for implementation. The assessment indicates a solid foundation for success."

      "proceed_with_caution" ->
        "With a suitability score of #{round(score)}%, this project can move forward with appropriate risk management. Address identified concerns early in the project lifecycle."

      "do_not_proceed" ->
        "With a suitability score of #{round(score)}%, additional work is needed before this project should proceed. The investment in addressing gaps will improve likelihood of success."
    end
  end

  defp assessment_summary_text(score) do
    cond do
      score >= 75 ->
        "The project shows strong potential for successful AI implementation."

      score >= 50 ->
        "The project has potential but requires attention in several areas before proceeding."

      true ->
        "Significant improvements are needed before this project should proceed with AI implementation."
    end
  end

  defp improvement_action(dimension) do
    actions = %{
      "problem_statement" =>
        "- **Problem Statement**: Clarify the specific business problem and its measurable impact",
      "solution_approach" =>
        "- **Solution Approach**: Define a clearer AI/ML approach with specific techniques",
      "data_availability" =>
        "- **Data Availability**: Identify and secure access to required data sources",
      "data_quality" =>
        "- **Data Quality**: Assess and improve data quality, consider data labeling",
      "technical_feasibility" =>
        "- **Technical Feasibility**: Evaluate infrastructure and team capabilities",
      "integration_requirements" =>
        "- **Integration**: Document integration requirements and API specifications",
      "success_criteria" => "- **Success Criteria**: Define specific, measurable success metrics",
      "user_requirements" => "- **User Requirements**: Conduct user research and define UX needs",
      "constraints" => "- **Constraints**: Document all constraints and validate assumptions",
      "risk_factors" => "- **Risk Factors**: Complete risk assessment and mitigation planning",
      "timeline" => "- **Timeline**: Develop detailed project schedule with milestones",
      "budget" => "- **Budget**: Create detailed cost estimates with contingency"
    }

    Map.get(actions, dimension, "- **#{humanize(dimension)}**: Address identified gaps")
  end

  # ============================================================================
  # Private - Helpers
  # ============================================================================

  defp get_dimension_data(data, dimension) do
    get_in(data, [:dimensions_data, dimension]) || %{confidence: 0.0, data: nil}
  end

  defp format_confidence(nil), do: "Not assessed"
  defp format_confidence(conf), do: "#{round(conf * 100)}%"

  defp format_date(nil), do: "Not specified"

  defp format_date(datetime) do
    Calendar.strftime(datetime, "%B %d, %Y")
  end

  defp format_status(status) do
    case status do
      :gathering -> "Gathering Information"
      :ready_for_report -> "Ready for Report"
      :report_generated -> "Report Generated"
      :editing -> "Editing"
      :exported -> "Exported"
      _ -> to_string(status)
    end
  end

  defp humanize(key) when is_atom(key), do: humanize(Atom.to_string(key))

  defp humanize(key) do
    key
    |> String.replace("_", " ")
    |> String.split()
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end
end
