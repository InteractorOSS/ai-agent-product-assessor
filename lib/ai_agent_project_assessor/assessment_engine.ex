defmodule AiAgentProjectAssessor.AssessmentEngine do
  @moduledoc """
  Core assessment engine that orchestrates the AI project assessment process.

  This module coordinates:
  - Interactor Agents for AI conversations
  - Interactor Workflows for state management
  - Dimension tracking across the 12-point methodology
  - Confidence calculation and progress tracking
  - Report generation

  ## Assessment Methodology

  The assessment tracks 12 dimensions:
  1. Problem Statement - Clarity of the business problem
  2. Solution Approach - Proposed AI solution design
  3. Data Availability - Access to required data
  4. Data Quality - Quality and completeness of data
  5. Technical Feasibility - Technical implementation viability
  6. Integration Requirements - System integration needs
  7. Success Criteria - Measurable success metrics
  8. User Requirements - End user needs and experience
  9. Constraints - Budget, timeline, regulatory constraints
  10. Risk Factors - Identified risks and mitigations
  11. Timeline - Project timeline and milestones
  12. Budget - Cost estimates and resource needs

  ## Usage

      {:ok, state} = AssessmentEngine.start_assessment(session)
      {:ok, state} = AssessmentEngine.process_input(session, state, "user input")
      {:ok, report} = AssessmentEngine.generate_report(session, state)

  """

  require Logger

  alias AiAgentProjectAssessor.Assessments
  alias AiAgentProjectAssessor.Reports
  alias AiAgentProjectAssessor.InteractorClient
  alias AiAgentProjectAssessor.InteractorClient.{Agents, Workflows}

  @dimensions [
    "problem_statement",
    "solution_approach",
    "data_availability",
    "data_quality",
    "technical_feasibility",
    "integration_requirements",
    "success_criteria",
    "user_requirements",
    "constraints",
    "risk_factors",
    "timeline",
    "budget"
  ]

  @confidence_threshold 0.95

  @type engine_state :: %{
          client: InteractorClient.t() | nil,
          room_id: String.t() | nil,
          workflow_instance_id: String.t() | nil,
          dimensions_data: map(),
          confidence: float(),
          dimensions_complete: integer(),
          last_response: String.t(),
          mode: :online | :offline
        }

  # ============================================================================
  # Public API
  # ============================================================================

  @doc """
  Starts a new assessment for the given session.

  Initializes the Interactor client, creates an agent room, and starts
  the workflow instance if online. Falls back to offline mode if
  Interactor services are unavailable.
  """
  @spec start_assessment(Assessments.Session.t()) :: {:ok, engine_state()} | {:error, term()}
  def start_assessment(session) do
    Logger.info("Starting assessment for session #{session.id}")

    case initialize_interactor() do
      {:ok, client} ->
        start_online_assessment(session, client)

      {:error, reason} ->
        Logger.warning("Interactor unavailable: #{inspect(reason)}, using offline mode")
        start_offline_assessment(session)
    end
  end

  @doc """
  Processes user input and returns the updated state with AI response.
  """
  @spec process_input(Assessments.Session.t(), engine_state(), String.t()) ::
          {:ok, engine_state()} | {:error, term()}
  def process_input(session, state, input) do
    case state.mode do
      :online -> process_online_input(session, state, input)
      :offline -> process_offline_input(session, state, input)
    end
  end

  @doc """
  Saves the current engine state to the session.
  """
  @spec save_state(Assessments.Session.t(), engine_state()) ::
          {:ok, Assessments.Session.t()} | {:error, term()}
  def save_state(session, state) do
    # Fetch the latest session from DB to avoid overwriting concurrent changes (like messages)
    fresh_session = Assessments.get_session(session.id)
    current_metadata = fresh_session.metadata || %{}

    # Merge dimensions_data into existing metadata, preserving messages
    updated_metadata = Map.put(current_metadata, "dimensions_data", state.dimensions_data)

    Assessments.update_session(fresh_session, %{
      confidence: state.confidence,
      dimensions_complete: state.dimensions_complete,
      workflow_instance_id: state.workflow_instance_id,
      agent_room_id: state.room_id,
      metadata: updated_metadata
    })
  end

  @doc """
  Generates the assessment report.
  """
  @spec generate_report(Assessments.Session.t(), engine_state()) ::
          {:ok, Reports.Report.t()} | {:error, term()}
  def generate_report(session, state) do
    Logger.info("Generating report for session #{session.id}")

    content = build_report_content(session, state)

    Reports.create_report(%{
      session_id: session.id,
      content: content,
      suitability_score: calculate_suitability_score(state),
      recommendation: determine_recommendation(state)
    })
  end

  @doc """
  Resumes an existing assessment from saved state.
  """
  @spec resume_assessment(Assessments.Session.t()) :: {:ok, engine_state()} | {:error, term()}
  def resume_assessment(session) do
    Logger.info("Resuming assessment for session #{session.id}")

    dimensions_data =
      get_in(session.metadata || %{}, ["dimensions_data"]) ||
        initialize_dimensions()

    state = %{
      client: nil,
      room_id: session.agent_room_id,
      workflow_instance_id: session.workflow_instance_id,
      dimensions_data: dimensions_data,
      confidence: session.confidence || 0.0,
      dimensions_complete: session.dimensions_complete || 0,
      last_response: "Welcome back! Let's continue where we left off.",
      mode: :offline
    }

    # Try to reconnect to Interactor
    case initialize_interactor() do
      {:ok, client} ->
        {:ok, %{state | client: client, mode: :online}}

      {:error, _} ->
        {:ok, state}
    end
  end

  @doc """
  Returns the list of assessment dimensions.
  """
  def dimensions, do: @dimensions

  @doc """
  Returns the confidence threshold for report generation.
  """
  def confidence_threshold, do: @confidence_threshold

  # ============================================================================
  # Private - Initialization
  # ============================================================================

  defp initialize_interactor do
    InteractorClient.new()
  end

  defp start_online_assessment(session, client) do
    namespace = "session:#{session.id}"

    with {:ok, room} <- Agents.create_room(client, namespace, %{session_id: session.id}),
         {:ok, workflow} <-
           Workflows.create_instance(client, namespace, %{
             input: session.initial_input,
             session_id: session.id
           }) do
      # Update session with Interactor IDs
      Assessments.update_interactor_ids(session, room.id, workflow.id)

      # Process initial input
      initial_response = process_initial_input(client, room.id, session.initial_input, namespace)

      state = %{
        client: client,
        room_id: room.id,
        workflow_instance_id: workflow.id,
        dimensions_data: initialize_dimensions(),
        confidence: 0.0,
        dimensions_complete: 0,
        last_response: initial_response,
        mode: :online
      }

      {:ok, state}
    else
      {:error, reason} ->
        Logger.warning("Failed to initialize online mode: #{inspect(reason)}")
        start_offline_assessment(session)
    end
  end

  defp start_offline_assessment(session) do
    initial_response = generate_offline_initial_response(session.initial_input)

    state = %{
      client: nil,
      room_id: nil,
      workflow_instance_id: nil,
      dimensions_data: initialize_dimensions(),
      confidence: 0.0,
      dimensions_complete: 0,
      last_response: initial_response,
      mode: :offline
    }

    {:ok, state}
  end

  defp initialize_dimensions do
    @dimensions
    |> Enum.map(fn dim -> {dim, %{confidence: 0.0, data: nil, notes: []}} end)
    |> Enum.into(%{})
  end

  # ============================================================================
  # Private - Input Processing
  # ============================================================================

  defp process_initial_input(client, room_id, input, namespace) do
    prompt = build_initial_prompt(input)

    case Agents.send_message(client, room_id, prompt, namespace) do
      {:ok, message} ->
        message.content

      {:error, _reason} ->
        generate_offline_initial_response(input)
    end
  end

  defp process_online_input(session, state, input) do
    namespace = "session:#{session.id}"

    case Agents.send_message(state.client, state.room_id, input, namespace) do
      {:ok, message} ->
        # Handle nil or empty content - fallback to offline response if no content
        response_content = message.content

        if is_nil(response_content) or response_content == "" do
          Logger.warning("API returned empty content, falling back to offline response")
          process_offline_input(session, state, input)
        else
          # Parse the AI response for dimension updates
          {updated_dimensions, _extracted_data} =
            analyze_response(response_content, state.dimensions_data)

          new_confidence = calculate_overall_confidence(updated_dimensions)
          complete_count = count_complete_dimensions(updated_dimensions)

          new_state = %{
            state
            | dimensions_data: updated_dimensions,
              confidence: new_confidence,
              dimensions_complete: complete_count,
              last_response: response_content
          }

          {:ok, new_state}
        end

      {:error, reason} ->
        Logger.error("Failed to send message: #{inspect(reason)}")
        # Fall back to offline processing
        process_offline_input(session, %{state | mode: :offline}, input)
    end
  end

  defp process_offline_input(_session, state, input) do
    Logger.info("Processing offline input (#{String.length(input)} chars)")

    # Offline mode - simulate AI response and dimension updates
    {updated_dimensions, _} = simulate_dimension_update(state.dimensions_data, input)

    new_confidence = calculate_overall_confidence(updated_dimensions)
    complete_count = count_complete_dimensions(updated_dimensions)

    response = generate_offline_response(updated_dimensions, new_confidence)

    Logger.info("Offline response generated: #{String.length(response)} chars, confidence: #{new_confidence}")

    new_state = %{
      state
      | dimensions_data: updated_dimensions,
        confidence: new_confidence,
        dimensions_complete: complete_count,
        last_response: response
    }

    {:ok, new_state}
  end

  # ============================================================================
  # Private - Response Analysis
  # ============================================================================

  defp analyze_response(response, dimensions_data) do
    # In a full implementation, this would parse structured output from the AI
    # For now, we simulate gradual dimension completion based on response length
    word_count = response |> String.split() |> length()
    confidence_boost = min(0.1, word_count / 500)

    updated =
      dimensions_data
      |> Enum.map(fn {dim, data} ->
        current_confidence = get_confidence(data)
        new_confidence = min(1.0, current_confidence + confidence_boost * :rand.uniform())
        {dim, put_confidence(data, new_confidence)}
      end)
      |> Enum.into(%{})

    {updated, %{}}
  end

  defp simulate_dimension_update(dimensions_data, input) do
    # Simulate dimension updates based on input keywords
    input_lower = String.downcase(input)
    word_count = input |> String.split() |> length()

    # Base boost scales with response length (longer = more info)
    length_factor = min(1.0, word_count / 50)

    dimension_keywords = %{
      "problem_statement" => ["problem", "challenge", "issue", "pain point", "need", "solve", "goal"],
      "solution_approach" => ["solution", "approach", "method", "ai", "machine learning", "model", "agent"],
      "data_availability" => ["data", "dataset", "records", "logs", "database", "source", "access"],
      "data_quality" => ["quality", "clean", "accurate", "complete", "labeled", "annotation"],
      "technical_feasibility" => ["technical", "infrastructure", "technology", "platform", "expertise", "team"],
      "integration_requirements" => ["integrate", "api", "system", "connect", "interface", "deploy"],
      "success_criteria" => ["success", "metric", "kpi", "measure", "goal", "roi", "performance"],
      "user_requirements" => ["user", "customer", "stakeholder", "experience", "interface", "ux"],
      "constraints" => ["constraint", "limitation", "regulation", "compliance", "security", "privacy"],
      "risk_factors" => ["risk", "concern", "challenge", "blocker", "obstacle", "failure"],
      "timeline" => ["timeline", "deadline", "schedule", "milestone", "phase", "stage", "week", "month"],
      "budget" => ["budget", "cost", "investment", "resource", "funding", "price", "$", "dollar"]
    }

    updated =
      dimensions_data
      |> Enum.map(fn {dim, data} ->
        keywords = Map.get(dimension_keywords, dim, [])
        keyword_matches = Enum.count(keywords, &String.contains?(input_lower, &1))

        # Significant boost for matching keywords, minimal for non-matching
        boost =
          if keyword_matches > 0 do
            # Strong boost when user talks about this dimension
            # Each keyword match adds 0.15, scaled by response length
            min(0.95, 0.20 + keyword_matches * 0.15 * length_factor)
          else
            # Minimal boost for non-matching dimensions
            0.02 * length_factor
          end

        current_confidence = get_confidence(data)
        new_confidence = min(1.0, current_confidence + boost)
        {dim, put_confidence(data, new_confidence)}
      end)
      |> Enum.into(%{})

    {updated, %{}}
  end

  # ============================================================================
  # Private - Confidence Calculation
  # ============================================================================

  defp calculate_overall_confidence(dimensions_data) do
    confidences =
      dimensions_data
      |> Enum.map(fn {_, data} -> get_confidence(data) end)

    if length(confidences) > 0 do
      Enum.sum(confidences) / length(confidences)
    else
      0.0
    end
  end

  defp count_complete_dimensions(dimensions_data) do
    dimensions_data
    |> Enum.count(fn {_, data} -> get_confidence(data) >= @confidence_threshold end)
  end

  # Helper to get confidence from data that may have atom or string keys (from JSON/DB)
  defp get_confidence(data) when is_map(data) do
    data[:confidence] || data["confidence"] || 0.0
  end

  # Helper to put confidence in data, preserving key type
  defp put_confidence(data, value) when is_map(data) do
    cond do
      Map.has_key?(data, :confidence) -> %{data | confidence: value}
      Map.has_key?(data, "confidence") -> Map.put(data, "confidence", value)
      true -> Map.put(data, "confidence", value)
    end
  end

  # ============================================================================
  # Private - Report Generation
  # ============================================================================

  defp build_report_content(session, state) do
    %{
      "executive_summary" => generate_executive_summary(session, state),
      "project_overview" => session.initial_input || "",
      "problem_statement" => get_dimension_content(state, "problem_statement"),
      "proposed_solution" => get_dimension_content(state, "solution_approach"),
      "data_assessment" => build_data_assessment(state),
      "technical_feasibility" => get_dimension_content(state, "technical_feasibility"),
      "integration_requirements" => get_dimension_content(state, "integration_requirements"),
      "success_criteria" => get_dimension_content(state, "success_criteria"),
      "user_requirements" => get_dimension_content(state, "user_requirements"),
      "constraints_assumptions" => get_dimension_content(state, "constraints"),
      "risk_register" => build_risk_register(state),
      "timeline_milestones" => get_dimension_content(state, "timeline"),
      "budget_estimates" => get_dimension_content(state, "budget"),
      "ai_suitability_score" => build_suitability_section(state),
      "recommendations" => build_recommendations(state)
    }
  end

  defp generate_executive_summary(session, state) do
    score = calculate_suitability_score(state)
    recommendation = determine_recommendation(state)

    """
    This assessment evaluates the feasibility and approach for: #{session.name}

    Overall AI Suitability Score: #{round(score)}%
    Recommendation: #{format_recommendation(recommendation)}

    The assessment covered #{state.dimensions_complete} of 12 key dimensions with
    an overall confidence level of #{round(state.confidence * 100)}%.
    """
  end

  defp get_dimension_content(state, dimension) do
    case get_in(state.dimensions_data, [dimension]) do
      %{data: data} when not is_nil(data) ->
        data

      _ ->
        "Information gathered during assessment. Confidence: #{get_dimension_confidence(state, dimension)}%"
    end
  end

  defp get_dimension_confidence(state, dimension) do
    case get_in(state.dimensions_data, [dimension, :confidence]) do
      nil -> 0
      conf -> round(conf * 100)
    end
  end

  defp build_data_assessment(state) do
    availability = get_dimension_confidence(state, "data_availability")
    quality = get_dimension_confidence(state, "data_quality")

    """
    Data Availability: #{availability}% confidence
    Data Quality: #{quality}% confidence

    Assessment based on information gathered during the evaluation process.
    """
  end

  defp build_risk_register(state) do
    risk_confidence = get_dimension_confidence(state, "risk_factors")

    """
    Risk assessment confidence: #{risk_confidence}%

    Key risks identified during assessment should be reviewed and mitigation
    strategies developed before project initiation.
    """
  end

  defp build_suitability_section(state) do
    score = calculate_suitability_score(state)

    dimension_scores =
      state.dimensions_data
      |> Enum.map(fn {dim, data} ->
        "- #{humanize_dimension(dim)}: #{round(get_confidence(data) * 100)}%"
      end)
      |> Enum.join("\n")

    """
    Overall AI Suitability Score: #{round(score)}%

    Dimension Scores:
    #{dimension_scores}
    """
  end

  defp build_recommendations(state) do
    recommendation = determine_recommendation(state)

    base_text =
      case recommendation do
        "proceed" ->
          "Based on the assessment, this project is well-suited for AI implementation."

        "proceed_with_caution" ->
          "This project shows potential for AI implementation but has areas requiring attention."

        "do_not_proceed" ->
          "The assessment indicates significant challenges that should be addressed before proceeding."
      end

    low_confidence_dims =
      state.dimensions_data
      |> Enum.filter(fn {_, data} -> get_confidence(data) < 0.7 end)
      |> Enum.map(fn {dim, _} -> humanize_dimension(dim) end)

    attention_items =
      if length(low_confidence_dims) > 0 do
        "\n\nAreas requiring attention:\n" <> Enum.map_join(low_confidence_dims, "\n", &"- #{&1}")
      else
        ""
      end

    base_text <> attention_items
  end

  defp calculate_suitability_score(state) do
    # Weighted average of dimension confidences
    weights = %{
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

    {weighted_sum, total_weight} =
      state.dimensions_data
      |> Enum.reduce({0.0, 0.0}, fn {dim, data}, {sum, weight} ->
        w = Map.get(weights, dim, 1.0)
        conf = get_confidence(data)
        {sum + conf * w, weight + w}
      end)

    if total_weight > 0 do
      weighted_sum / total_weight * 100
    else
      0.0
    end
  end

  defp determine_recommendation(state) do
    score = calculate_suitability_score(state)

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
    end
  end

  defp humanize_dimension(dim) do
    dim
    |> String.replace("_", " ")
    |> String.split()
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  # ============================================================================
  # Private - Offline Response Generation
  # ============================================================================

  defp build_initial_prompt(input) do
    """
    I'm starting an AI project assessment. Here's the initial project description:

    #{input}

    Please analyze this and help me understand what additional information is needed
    to fully assess the AI suitability of this project. Focus on the 12 key dimensions:
    problem clarity, solution approach, data availability, data quality, technical
    feasibility, integration needs, success criteria, user requirements, constraints,
    risks, timeline, and budget.
    """
  end

  defp generate_offline_initial_response(nil), do: generate_offline_initial_response("")

  defp generate_offline_initial_response(input) do
    word_count = input |> String.split() |> length()

    """
    ⚠️ **OFFLINE MODE** - Interactor AI is not connected. Using guided questionnaire instead.

    #{if word_count < 50 do
      "Your description is quite brief. Let's start by understanding the core problem you're trying to solve."
    else
      "Thank you for sharing your project idea. Let me ask some clarifying questions."
    end}

    To properly assess this project, I need to understand 12 key dimensions. Let's start with:

    **Problem Statement**:
    - What specific business problem are you trying to solve?
    - Who experiences this problem and how often?
    - What is the current impact of this problem?

    Please describe the problem in detail.
    """
  end

  defp generate_offline_response(dimensions_data, confidence) do
    # Sort dimensions by confidence (lowest first) so we ask about least complete
    # This ensures we progress through dimensions as they get answered
    incomplete_dims =
      dimensions_data
      |> Enum.filter(fn {_, data} -> get_confidence(data) < @confidence_threshold end)
      |> Enum.sort_by(fn {_, data} -> get_confidence(data) end)
      |> Enum.map(fn {dim, _} -> dim end)

    if confidence >= @confidence_threshold do
      """
      ⚠️ **OFFLINE MODE**

      Questionnaire complete! All 12 dimensions have been covered (#{round(confidence * 100)}% confidence).

      Click "Generate Report" to create your assessment report.

      _Note: For a more thorough AI-powered assessment, configure Interactor credentials._
      """
    else
      # Pick the dimension with lowest confidence to focus on next
      next_dim = List.first(incomplete_dims) || "problem_statement"
      question = get_dimension_question(next_dim)

      # Show progress on completed dimensions
      completed_count = 12 - length(incomplete_dims)

      """
      ⚠️ **OFFLINE MODE** | Progress: #{completed_count}/12 dimensions (#{round(confidence * 100)}%)

      #{question}
      """
    end
  end

  defp get_dimension_question(dimension) do
    questions = %{
      "problem_statement" => """
      Let's clarify the **Problem Statement**:
      - What specific problem are you trying to solve?
      - Who experiences this problem and how often?
      - What is the business impact of this problem?
      """,
      "solution_approach" => """
      Tell me about your **Proposed Solution**:
      - What AI/ML approach are you considering?
      - Why do you think AI is the right solution for this?
      - Are there existing solutions you've evaluated?
      """,
      "data_availability" => """
      Let's discuss **Data Availability**:
      - What data sources do you have access to?
      - How much historical data is available?
      - Is the data in a centralized location or distributed?
      """,
      "data_quality" => """
      Regarding **Data Quality**:
      - Is your data labeled or annotated?
      - Are there known data quality issues?
      - How complete is your dataset?
      """,
      "technical_feasibility" => """
      About **Technical Feasibility**:
      - What is your current technical infrastructure?
      - Do you have ML/AI expertise on your team?
      - What compute resources are available?
      """,
      "integration_requirements" => """
      For **Integration Requirements**:
      - What systems will this solution need to integrate with?
      - Are there API requirements or constraints?
      - What is your deployment environment?
      """,
      "success_criteria" => """
      Define your **Success Criteria**:
      - What metrics will determine success?
      - What is your target accuracy/performance?
      - How will you measure ROI?
      """,
      "user_requirements" => """
      About **User Requirements**:
      - Who are the end users of this solution?
      - What is their technical proficiency?
      - How will they interact with the system?
      """,
      "constraints" => """
      What **Constraints** should we consider?:
      - Are there regulatory or compliance requirements?
      - What are the security requirements?
      - Are there any organizational constraints?
      """,
      "risk_factors" => """
      Let's identify **Risk Factors**:
      - What do you see as the biggest risks?
      - Are there dependencies on external factors?
      - What happens if the project fails?
      """,
      "timeline" => """
      Regarding **Timeline**:
      - What is your target launch date?
      - Are there any hard deadlines?
      - What are the key milestones?
      """,
      "budget" => """
      Finally, about **Budget**:
      - What budget has been allocated?
      - What ongoing costs can be supported?
      - Are there resource constraints?
      """
    }

    Map.get(questions, dimension, "Please provide more information about your project.")
  end
end
