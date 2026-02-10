defmodule AiAgentProjectAssessorWeb.AssessmentLive.Show do
  @moduledoc """
  LiveView for the assessment conversation interface.

  Features:
  - Real-time chat interface with AI
  - Dimension progress tracking
  - Collapsible project details panel with auto-save
  - File upload for supporting documents
  - Generate report when ready
  """

  use AiAgentProjectAssessorWeb, :live_view

  require Logger

  alias AiAgentProjectAssessor.Assessments
  alias AiAgentProjectAssessor.AssessmentEngine

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    session = Assessments.get_session_with_preloads(id)

    if is_nil(session) do
      {:ok,
       socket
       |> put_flash(:error, "Assessment not found")
       |> push_navigate(to: ~p"/assessments")}
    else
      # Verify ownership
      if session.user_id != socket.assigns.current_user.id do
        {:ok,
         socket
         |> put_flash(:error, "Unauthorized")
         |> push_navigate(to: ~p"/assessments")}
      else
        if connected?(socket) do
          Phoenix.PubSub.subscribe(AiAgentProjectAssessor.PubSub, "session:#{id}")
        end

        # Initialize or resume assessment engine state using the real engine
        engine_state = initialize_or_resume_engine(session)

        # Determine current step based on session state (wizard pattern)
        # Step 1: Project Details (if no description yet)
        # Step 2: Assessment Chat (if has description, assessment in progress)
        # Step 3: Report (if report generated - redirects to report page)
        has_description = session.initial_input && String.trim(session.initial_input) != ""

        has_report = Ecto.assoc_loaded?(session.report) and not is_nil(session.report)

        current_step =
          cond do
            session.status == :report_generated && has_report -> 3
            has_description -> 2
            true -> 1
          end

        socket =
          socket
          |> assign(:session, session)
          |> assign(:engine_state, engine_state)
          |> assign(:messages, build_message_history(session, engine_state))
          |> assign(:input, "")
          |> assign(:sending, false)
          |> assign(:processing_phase, nil)
          |> assign(:processing_details, nil)
          |> assign(:generating_report, false)
          |> assign(:page_title, session.name)
          # Wizard step state
          |> assign(:current_step, current_step)
          # Project details form assigns
          |> assign(:project_name, session.name || "")
          |> assign(:project_description, session.initial_input || "")
          |> assign(:description_dirty, false)
          |> assign(:save_status, :saved)
          |> assign(:form_errors, %{})
          |> allow_upload(:documents,
            accept: ~w(.pdf .doc .docx .txt .md .csv .xls .xlsx .json),
            max_entries: 10,
            max_file_size: 10_000_000
          )

        {:ok, socket}
      end
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gray-50">
      <!-- Stepper Header -->
      <.stepper_header current_step={@current_step} session={@session} />
      
    <!-- Step Content -->
      <%= case @current_step do %>
        <% 1 -> %>
          <.step_1_project_details
            session={@session}
            project_name={@project_name}
            project_description={@project_description}
            save_status={@save_status}
            form_errors={@form_errors}
            uploads={@uploads}
          />
        <% 2 -> %>
          <.step_2_assessment
            session={@session}
            engine_state={@engine_state}
            messages={@messages}
            input={@input}
            sending={@sending}
            processing_phase={@processing_phase}
            processing_details={@processing_details}
            generating_report={@generating_report}
          />
        <% 3 -> %>
          <.step_3_report session={@session} />
      <% end %>
    </div>
    """
  end

  # ============================================================================
  # STEPPER HEADER COMPONENT
  # ============================================================================

  attr :current_step, :integer, required: true
  attr :session, :map, required: true

  defp stepper_header(assigns) do
    ~H"""
    <header class="bg-white border-b border-gray-200 sticky top-0 z-10">
      <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Back link and title -->
        <div class="py-4 flex items-center justify-between">
          <.link
            navigate={~p"/assessments"}
            class="flex items-center gap-2 text-gray-600 hover:text-gray-900"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M10 19l-7-7m0 0l7-7m-7 7h18"
              />
            </svg>
            <span class="text-sm">Back to Assessments</span>
          </.link>
          <div class="text-right">
            <h1 class="text-lg font-semibold text-gray-900 truncate max-w-xs">{@session.name}</h1>
          </div>
        </div>
        
    <!-- Step indicators -->
        <div class="pb-4">
          <nav aria-label="Progress">
            <ol role="list" class="flex items-center justify-center">
              <!-- Step 1 -->
              <li class="relative flex items-center">
                <.step_indicator
                  step={1}
                  current_step={@current_step}
                  label="Project Details"
                  description="Describe your project"
                />
              </li>
              
    <!-- Connector -->
              <li class="hidden sm:block w-24 lg:w-32">
                <div class={"h-0.5 #{if @current_step > 1, do: "bg-[#4CD964]", else: "bg-gray-200"}"}>
                </div>
              </li>
              
    <!-- Step 2 -->
              <li class="relative flex items-center">
                <.step_indicator
                  step={2}
                  current_step={@current_step}
                  label="Assessment"
                  description="Answer questions"
                />
              </li>
              
    <!-- Connector -->
              <li class="hidden sm:block w-24 lg:w-32">
                <div class={"h-0.5 #{if @current_step > 2, do: "bg-[#4CD964]", else: "bg-gray-200"}"}>
                </div>
              </li>
              
    <!-- Step 3 -->
              <li class="relative flex items-center">
                <.step_indicator
                  step={3}
                  current_step={@current_step}
                  label="Report"
                  description="View results"
                />
              </li>
            </ol>
          </nav>
        </div>
      </div>
    </header>
    """
  end

  attr :step, :integer, required: true
  attr :current_step, :integer, required: true
  attr :label, :string, required: true
  attr :description, :string, required: true

  defp step_indicator(assigns) do
    status =
      cond do
        assigns.current_step > assigns.step -> :complete
        assigns.current_step == assigns.step -> :current
        true -> :upcoming
      end

    assigns = assign(assigns, :status, status)

    ~H"""
    <div class="flex flex-col items-center">
      <!-- Circle indicator -->
      <div class={[
        "w-10 h-10 rounded-full flex items-center justify-center font-semibold text-sm transition-colors",
        @status == :complete && "bg-[#4CD964] text-white",
        @status == :current && "bg-[#4CD964] text-white ring-4 ring-green-100",
        @status == :upcoming && "bg-gray-200 text-gray-500"
      ]}>
        <%= if @status == :complete do %>
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
          </svg>
        <% else %>
          {@step}
        <% end %>
      </div>
      <!-- Label -->
      <div class="mt-2 text-center">
        <p class={[
          "text-sm font-medium",
          @status == :current && "text-[#4CD964]",
          @status == :complete && "text-gray-900",
          @status == :upcoming && "text-gray-500"
        ]}>
          {@label}
        </p>
        <p class="text-xs text-gray-500 hidden sm:block">{@description}</p>
      </div>
    </div>
    """
  end

  # ============================================================================
  # STEP 1: PROJECT DETAILS
  # ============================================================================

  attr :session, :map, required: true
  attr :project_name, :string, required: true
  attr :project_description, :string, required: true
  attr :save_status, :atom, required: true
  attr :form_errors, :map, required: true
  attr :uploads, :map, required: true

  defp step_1_project_details(assigns) do
    ~H"""
    <main class="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <!-- Hero section -->
      <div class="text-center mb-8">
        <div class="w-16 h-16 mx-auto bg-green-100 rounded-full flex items-center justify-center mb-4">
          <svg class="w-8 h-8 text-[#4CD964]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="1.5"
              d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
            />
          </svg>
        </div>
        <h2 class="text-2xl font-bold text-gray-900">Tell us about your project</h2>
        <p class="mt-2 text-gray-600">
          Provide details about your AI project so we can ask the right questions during the assessment.
        </p>
      </div>
      
    <!-- Form Card -->
      <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-6 sm:p-8">
        <form phx-submit="continue_to_assessment" phx-change="validate_step1">
          <!-- Project Name -->
          <div class="mb-6">
            <label for="project_name" class="block text-sm font-medium text-gray-700 mb-2">
              Project Name <span class="text-red-500">*</span>
            </label>
            <input
              type="text"
              id="project_name"
              name="project_name"
              value={@project_name}
              placeholder="e.g., Customer Churn Prediction System"
              class={"w-full px-4 py-3 border rounded-xl focus:ring-2 focus:ring-[#4CD964] focus:border-transparent transition-colors text-gray-900 #{if @form_errors[:name], do: "border-red-300 bg-red-50", else: "border-gray-300"}"}
            />
            <%= if @form_errors[:name] do %>
              <p class="mt-1 text-sm text-red-600">{@form_errors[:name]}</p>
            <% end %>
          </div>
          
    <!-- Project Description -->
          <div class="mb-6">
            <label for="project_description" class="block text-sm font-medium text-gray-700 mb-2">
              Project Description <span class="text-red-500">*</span>
            </label>
            <textarea
              id="project_description"
              name="project_description"
              rows="6"
              placeholder="Describe your AI project idea in detail. What problem are you trying to solve? Who will use this solution? What outcomes do you expect?"
              class={"w-full px-4 py-3 border rounded-xl focus:ring-2 focus:ring-[#4CD964] focus:border-transparent transition-colors resize-none text-gray-900 #{if @form_errors[:description], do: "border-red-300 bg-red-50", else: "border-gray-300"}"}
            ><%= @project_description %></textarea>
            <div class="mt-1 flex items-center justify-between">
              <%= if @form_errors[:description] do %>
                <p class="text-sm text-red-600">{@form_errors[:description]}</p>
              <% else %>
                <p class="text-xs text-gray-500">Minimum 50 characters for a thorough assessment</p>
              <% end %>
              <span class={"text-xs #{if String.length(@project_description) >= 50, do: "text-green-600", else: "text-gray-400"}"}>
                {String.length(@project_description)}/50
              </span>
            </div>
          </div>
          
    <!-- File Upload Section -->
          <div class="mb-8">
            <label class="block text-sm font-medium text-gray-700 mb-2">
              Supporting Documents <span class="text-gray-400 font-normal">(optional)</span>
            </label>
            <div
              class="border-2 border-dashed border-gray-300 rounded-xl p-6 text-center hover:border-[#4CD964] transition-colors cursor-pointer"
              phx-drop-target={@uploads.documents.ref}
            >
              <.live_file_input upload={@uploads.documents} class="hidden" />
              <svg
                class="mx-auto h-10 w-10 text-gray-400"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="1.5"
                  d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"
                />
              </svg>
              <p class="mt-2 text-sm text-gray-600">
                <label
                  for={@uploads.documents.ref}
                  class="cursor-pointer text-[#4CD964] hover:text-[#3DBF55] font-medium"
                >
                  Click to upload
                </label>
                or drag and drop
              </p>
              <p class="text-xs text-gray-500 mt-1">
                PDF, Word, Excel, TXT, Markdown, CSV, JSON (max 10MB each)
              </p>
            </div>
            
    <!-- Uploaded Files Preview -->
            <%= if length(@uploads.documents.entries) > 0 do %>
              <div class="mt-4 space-y-2">
                <%= for entry <- @uploads.documents.entries do %>
                  <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                    <div class="flex items-center gap-3 min-w-0">
                      <.file_icon ext={Path.extname(entry.client_name)} />
                      <div class="min-w-0">
                        <p class="text-sm font-medium text-gray-900 truncate">{entry.client_name}</p>
                        <p class="text-xs text-gray-500">{format_file_size(entry.client_size)}</p>
                        <%= for err <- upload_errors(@uploads.documents, entry) do %>
                          <p class="text-xs text-red-500">{upload_error_to_string(err)}</p>
                        <% end %>
                      </div>
                    </div>
                    <button
                      type="button"
                      phx-click="remove_upload"
                      phx-value-ref={entry.ref}
                      class="p-1 text-gray-400 hover:text-red-500"
                    >
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M6 18L18 6M6 6l12 12"
                        />
                      </svg>
                    </button>
                  </div>
                <% end %>
              </div>
            <% end %>
            
    <!-- Upload errors -->
            <%= for err <- upload_errors(@uploads.documents) do %>
              <p class="mt-2 text-sm text-red-500">{upload_error_to_string(err)}</p>
            <% end %>
            
    <!-- Existing uploaded files -->
            <%= if get_uploaded_files(@session) != [] do %>
              <div class="mt-4">
                <p class="text-xs text-gray-500 mb-2">Previously uploaded:</p>
                <div class="space-y-2">
                  <%= for file <- get_uploaded_files(@session) do %>
                    <div class="flex items-center justify-between p-3 bg-green-50 rounded-lg">
                      <div class="flex items-center gap-3 min-w-0">
                        <.file_icon ext={Path.extname(file["original_name"] || "")} />
                        <div class="min-w-0">
                          <p class="text-sm font-medium text-gray-900 truncate">
                            {file["original_name"]}
                          </p>
                          <p class="text-xs text-gray-500">{format_file_size(file["size"] || 0)}</p>
                        </div>
                      </div>
                      <svg
                        class="w-5 h-5 text-green-500"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M5 13l4 4L19 7"
                        />
                      </svg>
                    </div>
                  <% end %>
                </div>
              </div>
            <% end %>
          </div>
          
    <!-- Continue Button -->
          <div class="flex flex-col sm:flex-row gap-3">
            <button
              type="submit"
              class="flex-1 flex items-center justify-center gap-2 px-6 py-4 bg-[#4CD964] hover:bg-[#3DBF55] text-white font-semibold rounded-full shadow-md transition-colors text-lg"
            >
              Continue to Assessment
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M14 5l7 7m0 0l-7 7m7-7H3"
                />
              </svg>
            </button>
          </div>
        </form>
        
    <!-- Auto-save indicator -->
        <div class="mt-4 flex items-center justify-center">
          <.save_status_indicator status={@save_status} />
        </div>
      </div>
      
    <!-- Help text -->
      <div class="mt-6 text-center">
        <p class="text-sm text-gray-500">
          Your progress is automatically saved. You can return to this assessment at any time.
        </p>
      </div>
    </main>
    """
  end

  # ============================================================================
  # STEP 2: ASSESSMENT CHAT
  # ============================================================================

  attr :session, :map, required: true
  attr :engine_state, :map, required: true
  attr :messages, :list, required: true
  attr :input, :string, required: true
  attr :sending, :boolean, required: true
  attr :processing_phase, :string, default: nil
  attr :processing_details, :string, default: nil
  attr :generating_report, :boolean, required: true

  defp step_2_assessment(assigns) do
    ~H"""
    <div class="flex h-[calc(100vh-140px)]">
      <!-- Sidebar - Dimension Progress -->
      <aside class="w-72 bg-white border-r border-gray-200 flex flex-col hidden lg:flex">
        <!-- Progress Summary -->
        <div class="p-4 border-b border-gray-200">
          <div class="flex items-center justify-between text-sm mb-2">
            <span class="text-gray-600">Overall Progress</span>
            <span class="font-medium text-[#4CD964]">{round(@session.confidence * 100)}%</span>
          </div>
          <div class="h-2 bg-gray-200 rounded-full overflow-hidden">
            <div
              class="h-full bg-[#4CD964] transition-all duration-500"
              style={"width: #{round(@session.confidence * 100)}%"}
            >
            </div>
          </div>
          <p class="mt-2 text-xs text-gray-500 text-center">
            {@session.dimensions_complete}/12 dimensions explored
          </p>
        </div>
        
    <!-- Dimensions List -->
        <div class="flex-1 overflow-y-auto p-4">
          <h3 class="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-3">
            Assessment Dimensions
          </h3>
          <div class="space-y-2">
            <%= for {dimension, data} <- get_dimensions(@engine_state) do %>
              <.dimension_item dimension={dimension} data={data} />
            <% end %>
          </div>
        </div>
        
    <!-- Actions -->
        <div class="p-4 border-t border-gray-200 space-y-2">
          <!-- Edit Project Details -->
          <button
            phx-click="go_to_step"
            phx-value-step="1"
            class="w-full flex items-center justify-center gap-2 px-4 py-2 border border-gray-300 text-gray-700 hover:bg-gray-50 font-medium rounded-full transition-colors text-sm"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
              />
            </svg>
            Edit Project Details
          </button>

          <%= if @session.confidence >= 0.95 do %>
            <button
              phx-click="generate_report"
              disabled={@generating_report}
              class="w-full flex items-center justify-center gap-2 px-4 py-3 bg-[#4CD964] hover:bg-[#3DBF55] disabled:bg-gray-300 text-white font-medium rounded-full shadow-md transition-colors"
            >
              <%= if @generating_report do %>
                <svg class="animate-spin w-5 h-5" fill="none" viewBox="0 0 24 24">
                  <circle
                    class="opacity-25"
                    cx="12"
                    cy="12"
                    r="10"
                    stroke="currentColor"
                    stroke-width="4"
                  >
                  </circle>
                  <path
                    class="opacity-75"
                    fill="currentColor"
                    d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                  >
                  </path>
                </svg>
                Generating...
              <% else %>
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                  />
                </svg>
                Generate Report
              <% end %>
            </button>
          <% else %>
            <div class="text-center py-2 text-sm text-gray-500">
              Answer more questions to unlock report
            </div>
          <% end %>

          <%= if Ecto.assoc_loaded?(@session.report) and not is_nil(@session.report) do %>
            <.link
              navigate={~p"/reports/#{@session.report.id}"}
              class="w-full flex items-center justify-center gap-2 px-4 py-2 border border-[#4CD964] text-[#4CD964] hover:bg-green-50 font-medium rounded-full transition-colors"
            >
              View Report
            </.link>
          <% end %>
        </div>
      </aside>
      
    <!-- Main Chat Area -->
      <main class="flex-1 flex flex-col bg-gray-50">
        <!-- Chat Header -->
        <header class="bg-white border-b border-gray-200 px-6 py-3">
          <div class="flex items-center justify-between">
            <div class="flex items-center gap-3">
              <div class={"w-10 h-10 rounded-full flex items-center justify-center #{if @engine_state.mode == :online, do: "bg-[#4CD964]", else: "bg-amber-500"}"}>
                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
                  />
                </svg>
              </div>
              <div>
                <h1 class="font-semibold text-gray-900">
                  <%= if @engine_state.mode == :online do %>
                    AI Assessment Assistant
                  <% else %>
                    Assessment Questionnaire
                  <% end %>
                </h1>
                <p class="text-sm text-gray-500">
                  <%= if @engine_state.mode == :online do %>
                    AI-powered evaluation across 12 dimensions
                  <% else %>
                    <span class="text-amber-600 font-medium">OFFLINE</span> · Guided questionnaire mode
                  <% end %>
                </p>
              </div>
            </div>
            <!-- Mobile progress indicator -->
            <div class="lg:hidden flex items-center gap-2">
              <span class="text-sm font-medium text-[#4CD964]">
                {round(@session.confidence * 100)}%
              </span>
              <div class="w-16 h-2 bg-gray-200 rounded-full overflow-hidden">
                <div class="h-full bg-[#4CD964]" style={"width: #{round(@session.confidence * 100)}%"}>
                </div>
              </div>
            </div>
          </div>
        </header>
        
    <!-- Messages -->
        <div
          class="flex-1 overflow-y-auto p-6 space-y-6"
          id="messages-container"
          phx-hook="ScrollToBottom"
        >
          <%= for message <- @messages do %>
            <.message_bubble message={message} />
          <% end %>

          <%= if @sending do %>
            <div class="flex gap-4">
              <div class="w-10 h-10 rounded-full bg-[#4CD964] flex-shrink-0 flex items-center justify-center">
                <svg
                  class="w-6 h-6 text-white animate-pulse"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
                  />
                </svg>
              </div>
              <div class="bg-white rounded-2xl rounded-tl-none shadow-sm border border-gray-200 p-4 min-w-[280px] max-w-md">
                <div class="flex flex-col gap-3">
                  <!-- Main status with spinner -->
                  <div class="flex items-center gap-3">
                    <div class="relative">
                      <svg class="animate-spin h-5 w-5 text-[#4CD964]" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                      </svg>
                    </div>
                    <div class="flex-1">
                      <span class="text-sm font-semibold text-gray-800">{@processing_phase || "Processing..."}</span>
                    </div>
                  </div>

                  <!-- Details text (like Claude Code's secondary info) -->
                  <%= if @processing_details do %>
                    <div class="pl-8 border-l-2 border-[#4CD964]/30">
                      <p class="text-xs text-gray-500 leading-relaxed">{@processing_details}</p>
                    </div>
                  <% end %>

                  <!-- Animated dots indicator -->
                  <div class="flex items-center gap-2 pl-8">
                    <div class="flex gap-1">
                      <span class="w-1.5 h-1.5 bg-[#4CD964] rounded-full animate-bounce" style="animation-delay: 0ms;"></span>
                      <span class="w-1.5 h-1.5 bg-[#4CD964] rounded-full animate-bounce" style="animation-delay: 150ms;"></span>
                      <span class="w-1.5 h-1.5 bg-[#4CD964] rounded-full animate-bounce" style="animation-delay: 300ms;"></span>
                    </div>
                    <span class="text-xs text-gray-400">Working on it...</span>
                  </div>
                </div>
              </div>
            </div>
          <% end %>
        </div>
        
    <!-- Input Area -->
        <div class="bg-white border-t border-gray-200 p-4">
          <form phx-submit="send_message" phx-change="update_input" class="flex items-end gap-4">
            <div class="flex-1">
              <textarea
                name="message"
                id="message-input"
                rows="1"
                placeholder="Type your response..."
                class="w-full px-4 py-3 border border-gray-300 rounded-2xl focus:ring-2 focus:ring-[#4CD964] focus:border-transparent resize-none text-gray-900"
                phx-keydown="check_enter"
                phx-hook="AutoResizeTextarea"
                phx-debounce="100"
              ><%= @input %></textarea>
            </div>
            <button
              type="submit"
              disabled={@sending || String.trim(@input || "") == ""}
              class="flex-shrink-0 w-12 h-12 bg-[#4CD964] hover:bg-[#3DBF55] disabled:bg-gray-300 disabled:cursor-not-allowed text-white rounded-full flex items-center justify-center transition-colors"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8"
                />
              </svg>
            </button>
          </form>
          <div class="mt-2 text-xs text-gray-400 text-center">
            Press Enter to send, Shift+Enter for new line
          </div>
        </div>
      </main>
    </div>
    """
  end

  # ============================================================================
  # STEP 3: REPORT (Redirect)
  # ============================================================================

  attr :session, :map, required: true

  defp step_3_report(assigns) do
    ~H"""
    <main class="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8 py-16 text-center">
      <div class="w-20 h-20 mx-auto bg-green-100 rounded-full flex items-center justify-center mb-6">
        <svg class="w-10 h-10 text-[#4CD964]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
          />
        </svg>
      </div>
      <h2 class="text-2xl font-bold text-gray-900 mb-2">Assessment Complete!</h2>
      <p class="text-gray-600 mb-8">Your AI project suitability report is ready.</p>

      <%= if Ecto.assoc_loaded?(@session.report) and not is_nil(@session.report) do %>
        <.link
          navigate={~p"/reports/#{@session.report.id}"}
          class="inline-flex items-center gap-2 px-8 py-4 bg-[#4CD964] hover:bg-[#3DBF55] text-white font-semibold rounded-full shadow-md transition-colors text-lg"
        >
          View Your Report
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M14 5l7 7m0 0l-7 7m7-7H3"
            />
          </svg>
        </.link>
      <% else %>
        <p class="text-gray-500">Report is being generated...</p>
      <% end %>
    </main>
    """
  end

  # Save status indicator component
  attr :status, :atom, required: true

  defp save_status_indicator(assigns) do
    ~H"""
    <div class="flex items-center gap-1.5 text-xs">
      <%= case @status do %>
        <% :saved -> %>
          <svg
            class="w-3.5 h-3.5 text-green-500"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
          </svg>
          <span class="text-green-600">Saved</span>
        <% :saving -> %>
          <svg
            class="w-3.5 h-3.5 text-gray-400 animate-spin"
            fill="none"
            viewBox="0 0 24 24"
          >
            <circle
              class="opacity-25"
              cx="12"
              cy="12"
              r="10"
              stroke="currentColor"
              stroke-width="4"
            >
            </circle>
            <path
              class="opacity-75"
              fill="currentColor"
              d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
            >
            </path>
          </svg>
          <span class="text-gray-500">Saving...</span>
        <% :unsaved -> %>
          <svg
            class="w-3.5 h-3.5 text-amber-500"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
            />
          </svg>
          <span class="text-amber-600">Unsaved changes</span>
        <% :error -> %>
          <svg
            class="w-3.5 h-3.5 text-red-500"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M6 18L18 6M6 6l12 12"
            />
          </svg>
          <span class="text-red-600">Save failed - retrying...</span>
      <% end %>
    </div>
    """
  end

  # Message bubble component
  attr :message, :map, required: true

  defp message_bubble(assigns) do
    is_user = assigns.message.role == "user"
    assigns = assign(assigns, :is_user, is_user)

    ~H"""
    <div class={"flex gap-4 #{if @is_user, do: "flex-row-reverse"}"}>
      <%= if @is_user do %>
        <div class="w-10 h-10 rounded-full bg-gray-200 flex-shrink-0 flex items-center justify-center">
          <svg class="w-6 h-6 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"
            />
          </svg>
        </div>
      <% else %>
        <div class="w-10 h-10 rounded-full bg-[#4CD964] flex-shrink-0 flex items-center justify-center">
          <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
            />
          </svg>
        </div>
      <% end %>

      <div class={"max-w-2xl rounded-2xl shadow-sm border p-4 #{if @is_user, do: "bg-[#4CD964] text-white border-[#3DBF55] rounded-tr-none", else: "bg-white text-gray-900 border-gray-200 rounded-tl-none"}"}>
        <div class={"prose prose-sm max-w-none #{if @is_user, do: "prose-invert", else: "prose-gray [&>*]:text-gray-900 [&_strong]:text-gray-900 [&_a]:text-[#4CD964]"}"}>
          {raw(render_markdown(@message.content))}
        </div>
        <%= if @message[:timestamp] do %>
          <div class={"mt-2 text-xs #{if @is_user, do: "text-green-200", else: "text-gray-400"}"}>
            {format_time(@message.timestamp)}
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  # Dimension item component
  attr :dimension, :string, required: true
  attr :data, :map, required: true

  defp dimension_item(assigns) do
    confidence = assigns.data[:confidence] || 0
    status = dimension_status(confidence)

    assigns = assign(assigns, :confidence, confidence)
    assigns = assign(assigns, :status, status)

    ~H"""
    <div class="flex items-center gap-3 p-2 rounded-lg hover:bg-gray-50">
      <div class={"w-8 h-8 rounded-full flex items-center justify-center #{status_color(@status)}"}>
        <%= if @status == :complete do %>
          <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
          </svg>
        <% else %>
          <span class="text-xs font-medium">{round(@confidence * 100)}%</span>
        <% end %>
      </div>
      <div class="flex-1 min-w-0">
        <p class="text-sm font-medium text-gray-900 truncate">
          {humanize_dimension(@dimension)}
        </p>
        <p class="text-xs text-gray-500">
          {status_text(@status)}
        </p>
      </div>
    </div>
    """
  end

  # Status badge component
  attr :status, :atom, required: true

  defp status_badge(assigns) do
    {bg_class, text} =
      case assigns.status do
        :gathering -> {"bg-blue-100 text-blue-700", "In Progress"}
        :ready_for_report -> {"bg-amber-100 text-amber-700", "Ready"}
        :report_generated -> {"bg-green-100 text-green-700", "Completed"}
        _ -> {"bg-gray-100 text-gray-700", to_string(assigns.status)}
      end

    assigns = assign(assigns, :bg_class, bg_class)
    assigns = assign(assigns, :text, text)

    ~H"""
    <span class={"px-2 py-0.5 text-xs font-medium rounded-full #{@bg_class}"}>
      {@text}
    </span>
    """
  end

  # File icon component based on extension
  attr :ext, :string, required: true

  defp file_icon(assigns) do
    icon_class =
      case String.downcase(assigns.ext || "") do
        ".pdf" -> "text-red-500"
        ".doc" -> "text-blue-500"
        ".docx" -> "text-blue-500"
        ".xls" -> "text-green-600"
        ".xlsx" -> "text-green-600"
        ".csv" -> "text-green-600"
        ".json" -> "text-yellow-600"
        ".txt" -> "text-gray-500"
        ".md" -> "text-purple-500"
        _ -> "text-gray-400"
      end

    assigns = assign(assigns, :icon_class, icon_class)

    ~H"""
    <div class={"w-8 h-8 rounded-lg bg-gray-100 flex items-center justify-center #{@icon_class}"}>
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="1.5"
          d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"
        />
      </svg>
    </div>
    """
  end

  # Event handlers

  # ============================================================================
  # STEP NAVIGATION EVENTS
  # ============================================================================

  @impl true
  def handle_event("go_to_step", %{"step" => step_str}, socket) do
    step = String.to_integer(step_str)
    {:noreply, assign(socket, :current_step, step)}
  end

  def handle_event(
        "validate_step1",
        %{"project_name" => name, "project_description" => desc},
        socket
      ) do
    # Auto-save on change
    socket =
      socket
      |> assign(:project_name, name)
      |> assign(:project_description, desc)
      |> assign(:description_dirty, true)
      |> assign(:save_status, :saving)

    # Schedule auto-save
    send(self(), :do_save_step1)

    {:noreply, socket}
  end

  def handle_event(
        "continue_to_assessment",
        %{"project_name" => name, "project_description" => desc},
        socket
      ) do
    # Validate required fields
    errors = validate_step1_fields(name, desc)

    if map_size(errors) == 0 do
      # Save and proceed to step 2
      session = socket.assigns.session

      # Upload any pending files first
      socket = handle_pending_uploads(socket)

      case Assessments.update_session(session, %{name: name, initial_input: desc}) do
        {:ok, updated_session} ->
          # Rebuild messages with new description context
          engine_state = socket.assigns.engine_state
          messages = build_message_history(updated_session, engine_state)

          socket =
            socket
            |> assign(:session, updated_session)
            |> assign(:project_name, name)
            |> assign(:project_description, desc)
            |> assign(:messages, messages)
            |> assign(:current_step, 2)
            |> assign(:form_errors, %{})
            |> assign(:save_status, :saved)

          {:noreply, socket}

        {:error, _changeset} ->
          {:noreply,
           socket
           |> assign(:form_errors, %{general: "Failed to save. Please try again."})
           |> assign(:save_status, :error)}
      end
    else
      {:noreply, assign(socket, :form_errors, errors)}
    end
  end

  def handle_event("update_input", %{"message" => message}, socket) do
    {:noreply, assign(socket, :input, message)}
  end

  def handle_event("validate_upload", _params, socket) do
    # Phoenix LiveView automatically handles file staging
    # This handler is required for phx-change to work
    {:noreply, socket}
  end

  def handle_event("remove_upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :documents, ref)}
  end

  def handle_event("upload_documents", _params, socket) do
    session = socket.assigns.session

    # Create session-specific upload directory
    upload_dir = Path.join(["priv", "static", "uploads", "sessions", session.id])
    File.mkdir_p!(upload_dir)

    uploaded_files =
      consume_uploaded_entries(socket, :documents, fn %{path: path}, entry ->
        # Generate unique filename
        ext = Path.extname(entry.client_name)
        filename = "#{Ecto.UUID.generate()}#{ext}"
        dest = Path.join(upload_dir, filename)

        # Copy file to destination
        File.cp!(path, dest)

        # Return metadata about the uploaded file
        {:ok,
         %{
           "original_name" => entry.client_name,
           "filename" => filename,
           "path" => "/uploads/sessions/#{session.id}/#{filename}",
           "size" => entry.client_size,
           "type" => entry.client_type,
           "uploaded_at" => DateTime.utc_now() |> DateTime.to_iso8601()
         }}
      end)

    # Update session with file metadata
    if length(uploaded_files) > 0 do
      existing_files = get_uploaded_files(session)
      all_files = existing_files ++ uploaded_files

      case Assessments.update_session(session, %{
             metadata: Map.put(session.metadata || %{}, "uploaded_files", all_files)
           }) do
        {:ok, updated_session} ->
          socket =
            socket
            |> assign(:session, updated_session)
            |> put_flash(:info, "#{length(uploaded_files)} file(s) uploaded successfully")

          {:noreply, socket}

        {:error, _changeset} ->
          {:noreply, put_flash(socket, :error, "Failed to save file metadata")}
      end
    else
      {:noreply, socket}
    end
  end

  def handle_event("send_message", %{"message" => message}, socket) when message != "" do
    message = String.trim(message)

    if message == "" do
      {:noreply, socket}
    else
      session = socket.assigns.session

      # Add user message to display
      user_message = %{role: "user", content: message, timestamp: DateTime.utc_now()}

      # Persist user message to database
      {:ok, updated_session} = Assessments.append_message(session, user_message)

      socket =
        socket
        |> assign(:sending, true)
        |> assign(:processing_phase, "Sending your message...")
        |> assign(:processing_details, nil)
        |> assign(:input, "")
        |> assign(:session, updated_session)
        |> update(:messages, &(&1 ++ [user_message]))

      # Start async processing - first update UI, then process
      send(self(), {:start_processing, message})

      {:noreply, socket}
    end
  end

  def handle_event("send_message", _params, socket) do
    {:noreply, socket}
  end

  def handle_event(
        "check_enter",
        %{"key" => "Enter", "shiftKey" => false, "value" => value},
        socket
      ) do
    if String.trim(value) != "" do
      send(self(), {:submit_message, value})
    end

    {:noreply, socket}
  end

  def handle_event("check_enter", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("generate_report", _params, socket) do
    socket = assign(socket, :generating_report, true)
    send(self(), :do_generate_report)
    {:noreply, socket}
  end

  # Info handlers

  @impl true
  def handle_info(:do_save_step1, socket) do
    session = socket.assigns.session
    name = socket.assigns.project_name
    description = socket.assigns.project_description

    # Only save if there are actual changes
    if name != session.name || description != session.initial_input do
      case Assessments.update_session(session, %{name: name, initial_input: description}) do
        {:ok, updated_session} ->
          socket =
            socket
            |> assign(:session, updated_session)
            |> assign(:description_dirty, false)
            |> assign(:save_status, :saved)

          {:noreply, socket}

        {:error, _changeset} ->
          Process.send_after(self(), :retry_save_step1, 5000)
          {:noreply, assign(socket, :save_status, :error)}
      end
    else
      {:noreply, assign(socket, :save_status, :saved)}
    end
  end

  @impl true
  def handle_info(:retry_save_step1, socket) do
    if socket.assigns.description_dirty || socket.assigns.save_status == :error do
      send(self(), :do_save_step1)
    end

    {:noreply, socket}
  end

  @impl true
  def handle_info(:do_save_description, socket) do
    # Redirect to new handler
    send(self(), :do_save_step1)
    {:noreply, socket}
  end

  @impl true
  def handle_info(:retry_save_description, socket) do
    send(self(), :retry_save_step1)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:submit_message, message}, socket) do
    handle_event("send_message", %{"message" => message}, socket)
  end

  @impl true
  def handle_info({:start_processing, message}, socket) do
    # Step 1: Update UI to show we're connecting/analyzing
    engine_state = socket.assigns.engine_state
    mode_text = if engine_state.mode == :online, do: "Connecting to AI...", else: "Processing locally..."

    socket =
      socket
      |> assign(:processing_phase, mode_text)
      |> assign(:processing_details, "Preparing your request")

    # Schedule the actual processing after a brief delay to allow UI update
    Process.send_after(self(), {:do_process_message, message}, 50)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:do_process_message, message}, socket) do
    session = socket.assigns.session
    engine_state = socket.assigns.engine_state

    Logger.debug("Processing message for session #{session.id}, mode: #{engine_state.mode}")

    # Update to show we're analyzing
    socket =
      socket
      |> assign(:processing_phase, "Analyzing your input...")
      |> assign(:processing_details, "Understanding context and extracting key information")

    # Process through assessment engine (returns {:ok, new_state} with response in last_response)
    case AssessmentEngine.process_input(session, engine_state, message) do
      {:ok, new_state} ->
        # Update phase and schedule the save step with a brief delay for UI update
        socket =
          socket
          |> assign(:processing_phase, "Generating response...")
          |> assign(:processing_details, "Formulating assessment feedback")

        Process.send_after(self(), {:save_and_respond, new_state}, 50)
        {:noreply, socket}

      {:error, reason} ->
        error_message = %{
          role: "assistant",
          content:
            "I apologize, but I encountered an error: #{inspect(reason)}. Please try again.",
          timestamp: DateTime.utc_now()
        }

        socket =
          socket
          |> assign(:sending, false)
          |> assign(:processing_phase, nil)
          |> assign(:processing_details, nil)
          |> update(:messages, &(&1 ++ [error_message]))

        {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:save_and_respond, new_state}, socket) do
    # Update phase - saving state (UI will update before we continue)
    socket =
      socket
      |> assign(:processing_phase, "Updating assessment...")
      |> assign(:processing_details, "Saving progress and calculating confidence scores")

    # Schedule the actual save after UI update
    Process.send_after(self(), {:do_save_and_respond, new_state}, 50)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:do_save_and_respond, new_state}, socket) do
    try do
      session = socket.assigns.session
      Logger.info("[Assessment] do_save_and_respond starting for session #{session.id}")

      # Save state and update session in database
      {:ok, updated_session} = AssessmentEngine.save_state(session, new_state)
      Logger.info("[Assessment] State saved successfully")

      # Check if ready for report
      updated_session =
        if new_state.confidence >= 0.95 && session.status == :gathering do
          {:ok, s} = Assessments.transition_status(updated_session, :ready_for_report)
          s
        else
          updated_session
        end

      # Add assistant response from engine state (only if we have content)
      response_content = new_state.last_response
      Logger.info("[Assessment] Response received - length: #{if response_content, do: String.length(response_content), else: "nil"}, confidence: #{new_state.confidence}")

      # Create the assistant message
      assistant_message =
        if is_nil(response_content) or response_content == "" do
          Logger.warning("[Assessment] Empty response, using fallback message")
          %{
            role: "assistant",
            content: "Thank you for that information. Let me continue the assessment. What else can you tell me about your project?",
            timestamp: DateTime.utc_now()
          }
        else
          %{
            role: "assistant",
            content: response_content,
            timestamp: DateTime.utc_now()
          }
        end

      # Persist assistant message to database
      Logger.info("[Assessment] Persisting assistant message...")
      {:ok, updated_session} = Assessments.append_message(updated_session, assistant_message)
      Logger.info("[Assessment] Message persisted, updating socket...")

      current_message_count = length(socket.assigns.messages)
      Logger.info("[Assessment] Current messages: #{current_message_count}, adding 1 more")

      socket =
        socket
        |> assign(:session, updated_session)
        |> assign(:engine_state, new_state)
        |> assign(:sending, false)
        |> assign(:processing_phase, nil)
        |> assign(:processing_details, nil)
        |> update(:messages, &(&1 ++ [assistant_message]))

      Logger.info("[Assessment] Socket updated, new message count: #{length(socket.assigns.messages)}")

      {:noreply, socket}
    rescue
      e ->
        Logger.error("[Assessment] ERROR in do_save_and_respond: #{inspect(e)}")
        Logger.error("[Assessment] Stacktrace: #{Exception.format_stacktrace(__STACKTRACE__)}")

        socket =
          socket
          |> assign(:sending, false)
          |> assign(:processing_phase, nil)
          |> assign(:processing_details, nil)
          |> put_flash(:error, "An error occurred processing your message")

        {:noreply, socket}
    end
  end

  @impl true
  def handle_info(:do_generate_report, socket) do
    session = socket.assigns.session
    engine_state = socket.assigns.engine_state

    # Use AssessmentEngine.generate_report which handles the full state structure
    case AssessmentEngine.generate_report(session, engine_state) do
      {:ok, report} ->
        {:ok, updated_session} = Assessments.transition_status(session, :report_generated)

        socket =
          socket
          |> assign(:session, %{updated_session | report: report})
          |> assign(:generating_report, false)
          |> put_flash(:info, "Report generated successfully!")
          |> push_navigate(to: ~p"/reports/#{report.id}")

        {:noreply, socket}

      {:error, reason} ->
        socket =
          socket
          |> assign(:generating_report, false)
          |> put_flash(:error, "Failed to generate report: #{inspect(reason)}")

        {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:session_updated, updated_session}, socket) do
    {:noreply, assign(socket, :session, updated_session)}
  end

  # Private functions

  defp initialize_or_resume_engine(session) do
    # Check if this is a new or existing session
    has_existing_state =
      session.agent_room_id || session.workflow_instance_id ||
        get_in(session.metadata || %{}, ["dimensions_data"])

    result =
      if has_existing_state do
        # Resume existing assessment
        AssessmentEngine.resume_assessment(session)
      else
        # Start new assessment
        AssessmentEngine.start_assessment(session)
      end

    case result do
      {:ok, state} ->
        state

      {:error, reason} ->
        # Fall back to offline state if engine fails
        Logger.warning("Failed to initialize assessment engine: #{inspect(reason)}")

        %{
          client: nil,
          room_id: nil,
          workflow_instance_id: nil,
          dimensions_data: initialize_default_dimensions(),
          confidence: session.confidence || 0.0,
          dimensions_complete: session.dimensions_complete || 0,
          last_response: "Welcome! I'm here to help assess your AI project.",
          mode: :offline
        }
    end
  end

  defp initialize_default_dimensions do
    AssessmentEngine.dimensions()
    |> Enum.map(fn dim -> {dim, %{confidence: 0.0, data: nil, notes: []}} end)
    |> Enum.into(%{})
  end

  defp build_message_history(session, _engine_state) do
    # Load persisted messages from session metadata
    persisted_messages = Assessments.get_messages(session)

    if length(persisted_messages) > 0 do
      # Convert stored messages back to the format expected by the UI
      Enum.map(persisted_messages, fn msg ->
        %{
          role: msg["role"],
          content: msg["content"],
          timestamp: parse_timestamp(msg["timestamp"])
        }
      end)
    else
      # No messages yet - create welcome message
      welcome = create_welcome_message(session)

      # Persist the welcome message
      Assessments.append_message(session, welcome)

      [welcome]
    end
  end

  defp create_welcome_message(session) do
    has_description = session.initial_input && String.trim(session.initial_input) != ""

    welcome_content =
      if has_description do
        """
        Great, thanks for the project details! I'm ready to help assess **#{session.name}**.

        Based on your description, I'll ask you questions to evaluate your project across 12 key dimensions:
        - Problem definition & business value
        - Data availability & quality
        - Technical feasibility
        - Team capabilities
        - And 8 more...

        Let's start! #{get_initial_question(session)}
        """
      else
        """
        Hello! I'm here to help assess your AI project: **#{session.name}**.

        Let's start by understanding your project better. #{get_initial_question(session)}
        """
      end

    %{
      role: "assistant",
      content: welcome_content,
      timestamp: session.inserted_at
    }
  end

  defp parse_timestamp(nil), do: DateTime.utc_now()
  defp parse_timestamp(ts) when is_binary(ts) do
    case DateTime.from_iso8601(ts) do
      {:ok, dt, _offset} -> dt
      _ -> DateTime.utc_now()
    end
  end
  defp parse_timestamp(%DateTime{} = dt), do: dt

  defp get_initial_question(session) do
    if session.initial_input && String.length(session.initial_input || "") > 50 do
      "Can you tell me more about the specific problem you're trying to solve?"
    else
      "What business problem are you trying to solve with AI?"
    end
  end

  defp get_dimensions(engine_state) do
    # Use dimensions_data from the engine state (matches AssessmentEngine format)
    dimensions_data = engine_state.dimensions_data || %{}

    AssessmentEngine.dimensions()
    |> Enum.map(fn dim ->
      {dim, Map.get(dimensions_data, dim, %{confidence: 0.0, data: nil})}
    end)
  end

  defp get_uploaded_files(session) do
    get_in(session.metadata || %{}, ["uploaded_files"]) || []
  end

  defp dimension_status(confidence) do
    cond do
      confidence >= 0.8 -> :complete
      confidence >= 0.5 -> :partial
      confidence > 0 -> :started
      true -> :not_started
    end
  end

  defp status_color(:complete), do: "bg-[#4CD964]"
  defp status_color(:partial), do: "bg-amber-400 text-white"
  defp status_color(:started), do: "bg-blue-400 text-white"
  defp status_color(:not_started), do: "bg-gray-200 text-gray-600"

  defp status_text(:complete), do: "Complete"
  defp status_text(:partial), do: "Needs more detail"
  defp status_text(:started), do: "In progress"
  defp status_text(:not_started), do: "Not started"

  defp humanize_dimension(dimension) do
    dimension
    |> String.replace("_", " ")
    |> String.split()
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  defp render_markdown(content) do
    content
    |> String.replace(~r/\*\*(.+?)\*\*/, "<strong>\\1</strong>")
    |> String.replace(~r/\*(.+?)\*/, "<em>\\1</em>")
    |> String.replace(~r/^- (.+)$/m, "<li>\\1</li>")
    |> String.replace(~r/(<li>.+<\/li>\n?)+/, "<ul>\\0</ul>")
    |> String.replace("\n\n", "<br><br>")
    |> String.replace("\n", "<br>")
  end

  defp format_time(datetime) do
    Calendar.strftime(datetime, "%I:%M %p")
  end

  defp format_file_size(size) when is_integer(size) and size < 1024, do: "#{size} B"

  defp format_file_size(size) when is_integer(size) and size < 1024 * 1024,
    do: "#{Float.round(size / 1024, 1)} KB"

  defp format_file_size(size) when is_integer(size),
    do: "#{Float.round(size / 1024 / 1024, 1)} MB"

  defp format_file_size(_), do: "Unknown"

  defp upload_error_to_string(:too_large), do: "File is too large (max 10MB)"
  defp upload_error_to_string(:too_many_files), do: "Too many files (max 10)"
  defp upload_error_to_string(:not_accepted), do: "File type not accepted"
  defp upload_error_to_string(err), do: "Upload error: #{inspect(err)}"

  # Step 1 validation helpers
  defp validate_step1_fields(name, description) do
    errors = %{}

    errors =
      if String.trim(name) == "" do
        Map.put(errors, :name, "Project name is required")
      else
        errors
      end

    errors =
      cond do
        String.trim(description) == "" ->
          Map.put(errors, :description, "Project description is required")

        String.length(String.trim(description)) < 50 ->
          Map.put(
            errors,
            :description,
            "Please provide at least 50 characters for a thorough assessment"
          )

        true ->
          errors
      end

    errors
  end

  defp handle_pending_uploads(socket) do
    # If there are files in the upload queue, process them
    if length(socket.assigns.uploads.documents.entries) > 0 do
      session = socket.assigns.session
      upload_dir = Path.join(["priv", "static", "uploads", "sessions", session.id])
      File.mkdir_p!(upload_dir)

      uploaded_files =
        consume_uploaded_entries(socket, :documents, fn %{path: path}, entry ->
          ext = Path.extname(entry.client_name)
          filename = "#{Ecto.UUID.generate()}#{ext}"
          dest = Path.join(upload_dir, filename)
          File.cp!(path, dest)

          {:ok,
           %{
             "original_name" => entry.client_name,
             "filename" => filename,
             "path" => "/uploads/sessions/#{session.id}/#{filename}",
             "size" => entry.client_size,
             "type" => entry.client_type,
             "uploaded_at" => DateTime.utc_now() |> DateTime.to_iso8601()
           }}
        end)

      if length(uploaded_files) > 0 do
        existing_files = get_uploaded_files(session)
        all_files = existing_files ++ uploaded_files

        case Assessments.update_session(session, %{
               metadata: Map.put(session.metadata || %{}, "uploaded_files", all_files)
             }) do
          {:ok, updated_session} -> assign(socket, :session, updated_session)
          {:error, _} -> socket
        end
      else
        socket
      end
    else
      socket
    end
  end
end
