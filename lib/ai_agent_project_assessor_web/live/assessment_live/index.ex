defmodule AiAgentProjectAssessorWeb.AssessmentLive.Index do
  @moduledoc """
  LiveView for listing and managing assessment sessions.

  Features:
  - List all user assessments
  - Filter by status
  - Search by name
  - Quick actions (continue, view report, delete)
  """

  use AiAgentProjectAssessorWeb, :live_view

  alias AiAgentProjectAssessor.Assessments
  alias AiAgentProjectAssessor.Assessments.Session

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    if connected?(socket) do
      # Subscribe to assessment updates
      Phoenix.PubSub.subscribe(AiAgentProjectAssessor.PubSub, "user:#{user.id}:assessments")
    end

    socket =
      socket
      |> assign(:page_title, "My Assessments")
      |> assign(:filter_status, nil)
      |> assign(:search_query, "")
      |> load_sessions()

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "My Assessments")
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gray-50">
      <!-- Header -->
      <header class="bg-white border-b border-gray-200">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <div class="flex items-center justify-between">
            <div>
              <h1 class="text-2xl font-semibold text-gray-900">My Assessments</h1>
              <p class="mt-1 text-sm text-gray-500">
                Manage your AI project assessments
              </p>
            </div>
            <.link
              navigate={~p"/assessments/new"}
              class="inline-flex items-center gap-2 px-6 py-3 bg-[#4CD964] hover:bg-[#3DBF55] text-white font-medium rounded-full shadow-md transition-colors"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M12 4v16m8-8H4"
                />
              </svg>
              New Assessment
            </.link>
          </div>
        </div>
      </header>
      
    <!-- Filters -->
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
        <div class="flex flex-wrap items-center gap-4">
          <!-- Search -->
          <div class="flex-1 min-w-[200px] max-w-md">
            <div class="relative">
              <svg
                class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
                />
              </svg>
              <input
                type="text"
                placeholder="Search assessments..."
                value={@search_query}
                phx-keyup="search"
                phx-debounce="300"
                class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-full focus:ring-2 focus:ring-[#4CD964] focus:border-transparent"
              />
            </div>
          </div>
          
    <!-- Status Filter -->
          <div class="flex items-center gap-2">
            <span class="text-sm text-gray-500">Status:</span>
            <div class="flex gap-1">
              <button
                phx-click="filter"
                phx-value-status=""
                class={"px-3 py-1.5 text-sm rounded-full transition-colors #{if @filter_status == nil, do: "bg-[#4CD964] text-white", else: "bg-gray-100 text-gray-700 hover:bg-gray-200"}"}
              >
                All
              </button>
              <button
                phx-click="filter"
                phx-value-status="gathering"
                class={"px-3 py-1.5 text-sm rounded-full transition-colors #{if @filter_status == :gathering, do: "bg-[#4CD964] text-white", else: "bg-gray-100 text-gray-700 hover:bg-gray-200"}"}
              >
                In Progress
              </button>
              <button
                phx-click="filter"
                phx-value-status="ready_for_report"
                class={"px-3 py-1.5 text-sm rounded-full transition-colors #{if @filter_status == :ready_for_report, do: "bg-[#4CD964] text-white", else: "bg-gray-100 text-gray-700 hover:bg-gray-200"}"}
              >
                Ready
              </button>
              <button
                phx-click="filter"
                phx-value-status="report_generated"
                class={"px-3 py-1.5 text-sm rounded-full transition-colors #{if @filter_status == :report_generated, do: "bg-[#4CD964] text-white", else: "bg-gray-100 text-gray-700 hover:bg-gray-200"}"}
              >
                Completed
              </button>
            </div>
          </div>
        </div>
      </div>
      
    <!-- Sessions List -->
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-8">
        <%= if Enum.empty?(@sessions) do %>
          <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-12 text-center">
            <svg
              class="mx-auto w-16 h-16 text-gray-300"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="1.5"
                d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"
              />
            </svg>
            <h3 class="mt-4 text-lg font-medium text-gray-900">No assessments yet</h3>
            <p class="mt-2 text-gray-500">
              Get started by creating your first AI project assessment.
            </p>
            <.link
              navigate={~p"/assessments/new"}
              class="mt-6 inline-flex items-center gap-2 px-6 py-3 bg-[#4CD964] hover:bg-[#3DBF55] text-white font-medium rounded-full shadow-md transition-colors"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M12 4v16m8-8H4"
                />
              </svg>
              Create Assessment
            </.link>
          </div>
        <% else %>
          <div class="grid gap-4">
            <%= for session <- @sessions do %>
              <.session_card session={session} />
            <% end %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  # Session card component
  attr :session, Session, required: true

  defp session_card(assigns) do
    ~H"""
    <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow">
      <div class="flex items-start justify-between">
        <div class="flex-1">
          <div class="flex items-center gap-3">
            <h3 class="text-lg font-semibold text-gray-900">
              {@session.name}
            </h3>
            <.status_badge status={@session.status} />
          </div>

          <%= if @session.initial_input do %>
            <p class="mt-2 text-gray-600 line-clamp-2">
              {String.slice(@session.initial_input, 0, 150)}{if String.length(
                                                                  @session.initial_input || ""
                                                                ) > 150,
                                                                do: "..."}
            </p>
          <% end %>

          <div class="mt-4 flex items-center gap-6 text-sm text-gray-500">
            <div class="flex items-center gap-1">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
                />
              </svg>
              <span>Confidence: {round(@session.confidence * 100)}%</span>
            </div>
            <div class="flex items-center gap-1">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"
                />
              </svg>
              <span>Updated {format_relative_time(@session.updated_at)}</span>
            </div>
            <div class="flex items-center gap-1">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"
                />
              </svg>
              <span>{@session.dimensions_complete}/12 dimensions</span>
            </div>
          </div>
        </div>
        
    <!-- Progress Ring -->
        <div class="ml-6 flex flex-col items-center">
          <.progress_ring percentage={round(@session.confidence * 100)} />
        </div>
      </div>
      
    <!-- Actions -->
      <div class="mt-6 pt-4 border-t border-gray-100 flex items-center justify-between">
        <div class="flex items-center gap-2">
          <%= if @session.status in [:gathering, :ready_for_report] do %>
            <.link
              navigate={~p"/assessments/#{@session.id}"}
              class="inline-flex items-center gap-2 px-4 py-2 bg-[#4CD964] hover:bg-[#3DBF55] text-white text-sm font-medium rounded-full transition-colors"
            >
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z"
                />
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                />
              </svg>
              Continue
            </.link>
          <% end %>

          <%= if @session.status == :report_generated do %>
            <.link
              navigate={~p"/reports/#{@session.id}"}
              class="inline-flex items-center gap-2 px-4 py-2 bg-[#4CD964] hover:bg-[#3DBF55] text-white text-sm font-medium rounded-full transition-colors"
            >
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                />
              </svg>
              View Report
            </.link>
          <% end %>

          <.link
            navigate={~p"/assessments/#{@session.id}"}
            class="inline-flex items-center gap-2 px-4 py-2 border border-gray-300 text-gray-700 hover:bg-gray-50 text-sm font-medium rounded-full transition-colors"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
              />
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"
              />
            </svg>
            View Details
          </.link>
        </div>

        <button
          phx-click="delete"
          phx-value-id={@session.id}
          data-confirm="Are you sure you want to delete this assessment? This action cannot be undone."
          class="text-gray-400 hover:text-red-500 transition-colors"
        >
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
            />
          </svg>
        </button>
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
        :ready_for_report -> {"bg-amber-100 text-amber-700", "Ready for Report"}
        :report_generated -> {"bg-green-100 text-green-700", "Completed"}
        :editing -> {"bg-purple-100 text-purple-700", "Editing"}
        :exported -> {"bg-gray-100 text-gray-700", "Exported"}
        _ -> {"bg-gray-100 text-gray-700", to_string(assigns.status)}
      end

    assigns = assign(assigns, :bg_class, bg_class)
    assigns = assign(assigns, :text, text)

    ~H"""
    <span class={"px-2.5 py-0.5 text-xs font-medium rounded-full #{@bg_class}"}>
      {@text}
    </span>
    """
  end

  # Progress ring component
  attr :percentage, :integer, required: true

  defp progress_ring(assigns) do
    circumference = 2 * :math.pi() * 20
    stroke_dashoffset = circumference - assigns.percentage / 100 * circumference

    assigns = assign(assigns, :circumference, circumference)
    assigns = assign(assigns, :stroke_dashoffset, stroke_dashoffset)

    color =
      cond do
        assigns.percentage >= 95 -> "#4CD964"
        assigns.percentage >= 75 -> "#FFCC00"
        assigns.percentage >= 50 -> "#FF9500"
        true -> "#FF3B30"
      end

    assigns = assign(assigns, :color, color)

    ~H"""
    <div class="relative w-16 h-16">
      <svg class="w-16 h-16 transform -rotate-90">
        <circle
          cx="32"
          cy="32"
          r="20"
          stroke="#E5E7EB"
          stroke-width="4"
          fill="none"
        />
        <circle
          cx="32"
          cy="32"
          r="20"
          stroke={@color}
          stroke-width="4"
          fill="none"
          stroke-linecap="round"
          stroke-dasharray={@circumference}
          stroke-dashoffset={@stroke_dashoffset}
        />
      </svg>
      <div class="absolute inset-0 flex items-center justify-center">
        <span class="text-sm font-semibold text-gray-900">{@percentage}%</span>
      </div>
    </div>
    """
  end

  # Event handlers

  @impl true
  def handle_event("search", %{"value" => query}, socket) do
    socket =
      socket
      |> assign(:search_query, query)
      |> load_sessions()

    {:noreply, socket}
  end

  @impl true
  def handle_event("filter", %{"status" => ""}, socket) do
    socket =
      socket
      |> assign(:filter_status, nil)
      |> load_sessions()

    {:noreply, socket}
  end

  @impl true
  def handle_event("filter", %{"status" => status}, socket) do
    socket =
      socket
      |> assign(:filter_status, String.to_existing_atom(status))
      |> load_sessions()

    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    session = Assessments.get_session!(id)

    # Verify ownership
    if session.user_id == socket.assigns.current_user.id do
      case Assessments.delete_session(session) do
        {:ok, _} ->
          socket =
            socket
            |> put_flash(:info, "Assessment deleted successfully")
            |> load_sessions()

          {:noreply, socket}

        {:error, _} ->
          {:noreply, put_flash(socket, :error, "Failed to delete assessment")}
      end
    else
      {:noreply, put_flash(socket, :error, "Unauthorized")}
    end
  end

  # PubSub handlers
  @impl true
  def handle_info({:session_updated, _session}, socket) do
    {:noreply, load_sessions(socket)}
  end

  @impl true
  def handle_info({:session_created, _session}, socket) do
    {:noreply, load_sessions(socket)}
  end

  # Private functions

  defp load_sessions(socket) do
    user = socket.assigns.current_user
    filter_status = socket.assigns[:filter_status]
    search_query = socket.assigns[:search_query] || ""

    sessions =
      if filter_status do
        Assessments.list_sessions_by_status(user.id, filter_status)
      else
        Assessments.list_sessions(user.id)
      end

    # Apply search filter
    sessions =
      if search_query != "" do
        query_lower = String.downcase(search_query)

        Enum.filter(sessions, fn session ->
          String.contains?(String.downcase(session.name || ""), query_lower) ||
            String.contains?(String.downcase(session.initial_input || ""), query_lower)
        end)
      else
        sessions
      end

    assign(socket, :sessions, sessions)
  end

  defp format_relative_time(datetime) do
    now = DateTime.utc_now()
    diff = DateTime.diff(now, datetime, :second)

    cond do
      diff < 60 -> "just now"
      diff < 3600 -> "#{div(diff, 60)} min ago"
      diff < 86400 -> "#{div(diff, 3600)} hours ago"
      diff < 604_800 -> "#{div(diff, 86400)} days ago"
      true -> Calendar.strftime(datetime, "%b %d, %Y")
    end
  end
end
