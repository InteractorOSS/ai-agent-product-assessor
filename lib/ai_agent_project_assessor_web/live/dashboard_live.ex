defmodule AiAgentProjectAssessorWeb.DashboardLive do
  @moduledoc """
  Dashboard LiveView for authenticated users.

  Features:
  - Quick stats overview
  - Recent assessments
  - Quick actions
  """

  use AiAgentProjectAssessorWeb, :live_view

  alias AiAgentProjectAssessor.Assessments

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    if connected?(socket) do
      Phoenix.PubSub.subscribe(AiAgentProjectAssessor.PubSub, "user:#{user.id}:assessments")
    end

    socket =
      socket
      |> assign(:page_title, "Dashboard")
      |> load_stats()
      |> load_recent_sessions()

    {:ok, socket}
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
              <h1 class="text-2xl font-semibold text-gray-900">
                Welcome back, {@current_user.name || "there"}!
              </h1>
              <p class="mt-1 text-sm text-gray-500">
                Here's an overview of your AI project assessments
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
      
    <!-- Main Content -->
      <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Stats Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <.stat_card
            title="Total Assessments"
            value={@stats.total}
            icon="clipboard-list"
            color="blue"
          />
          <.stat_card
            title="In Progress"
            value={@stats.in_progress}
            icon="refresh"
            color="amber"
          />
          <.stat_card
            title="Completed"
            value={@stats.completed}
            icon="check-circle"
            color="green"
          />
          <.stat_card
            title="Reports Generated"
            value={@stats.reports}
            icon="document-text"
            color="purple"
          />
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
          <!-- Recent Assessments -->
          <div class="lg:col-span-2">
            <div class="bg-white rounded-2xl shadow-sm border border-gray-200">
              <div class="p-6 border-b border-gray-200">
                <div class="flex items-center justify-between">
                  <h2 class="text-lg font-semibold text-gray-900">Recent Assessments</h2>
                  <.link
                    navigate={~p"/assessments"}
                    class="text-sm text-[#4CD964] hover:text-[#3DBF55] font-medium"
                  >
                    View all →
                  </.link>
                </div>
              </div>

              <%= if Enum.empty?(@recent_sessions) do %>
                <div class="p-12 text-center">
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
                      d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"
                    />
                  </svg>
                  <h3 class="mt-4 text-lg font-medium text-gray-900">No assessments yet</h3>
                  <p class="mt-2 text-gray-500">
                    Create your first AI project assessment to get started.
                  </p>
                  <.link
                    navigate={~p"/assessments/new"}
                    class="mt-6 inline-flex items-center gap-2 px-6 py-3 bg-[#4CD964] hover:bg-[#3DBF55] text-white font-medium rounded-full shadow-md transition-colors"
                  >
                    Create Assessment
                  </.link>
                </div>
              <% else %>
                <div class="divide-y divide-gray-100">
                  <%= for session <- @recent_sessions do %>
                    <.link
                      navigate={~p"/assessments/#{session.id}"}
                      class="block p-4 hover:bg-gray-50 transition-colors"
                    >
                      <div class="flex items-center justify-between">
                        <div class="flex-1 min-w-0">
                          <div class="flex items-center gap-3">
                            <p class="font-medium text-gray-900 truncate">{session.name}</p>
                            <.status_badge status={session.status} />
                          </div>
                          <p class="mt-1 text-sm text-gray-500">
                            Updated {format_relative_time(session.updated_at)}
                          </p>
                        </div>
                        <div class="ml-4 flex items-center gap-4">
                          <div class="text-right">
                            <p class="text-sm font-medium text-gray-900">
                              {round(session.confidence * 100)}%
                            </p>
                            <p class="text-xs text-gray-500">complete</p>
                          </div>
                          <svg
                            class="w-5 h-5 text-gray-400"
                            fill="none"
                            stroke="currentColor"
                            viewBox="0 0 24 24"
                          >
                            <path
                              stroke-linecap="round"
                              stroke-linejoin="round"
                              stroke-width="2"
                              d="M9 5l7 7-7 7"
                            />
                          </svg>
                        </div>
                      </div>
                    </.link>
                  <% end %>
                </div>
              <% end %>
            </div>
          </div>
          
    <!-- Quick Actions & Info -->
          <div class="space-y-6">
            <!-- Quick Actions -->
            <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-6">
              <h2 class="text-lg font-semibold text-gray-900 mb-4">Quick Actions</h2>
              <div class="space-y-3">
                <.link
                  navigate={~p"/assessments/new"}
                  class="flex items-center gap-3 p-3 rounded-xl hover:bg-gray-50 transition-colors"
                >
                  <div class="w-10 h-10 rounded-full bg-green-100 flex items-center justify-center">
                    <svg
                      class="w-5 h-5 text-[#4CD964]"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M12 4v16m8-8H4"
                      />
                    </svg>
                  </div>
                  <div>
                    <p class="font-medium text-gray-900">New Assessment</p>
                    <p class="text-xs text-gray-500">Start a new AI project evaluation</p>
                  </div>
                </.link>

                <.link
                  navigate={~p"/assessments"}
                  class="flex items-center gap-3 p-3 rounded-xl hover:bg-gray-50 transition-colors"
                >
                  <div class="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center">
                    <svg
                      class="w-5 h-5 text-blue-600"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"
                      />
                    </svg>
                  </div>
                  <div>
                    <p class="font-medium text-gray-900">View All Assessments</p>
                    <p class="text-xs text-gray-500">Manage your projects</p>
                  </div>
                </.link>

                <%= if @stats.completed > 0 do %>
                  <div class="flex items-center gap-3 p-3 rounded-xl hover:bg-gray-50 transition-colors cursor-pointer">
                    <div class="w-10 h-10 rounded-full bg-purple-100 flex items-center justify-center">
                      <svg
                        class="w-5 h-5 text-purple-600"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                        />
                      </svg>
                    </div>
                    <div>
                      <p class="font-medium text-gray-900">Export Reports</p>
                      <p class="text-xs text-gray-500">Download as PDF</p>
                    </div>
                  </div>
                <% end %>
              </div>
            </div>
            
    <!-- Assessment Process -->
            <div class="bg-gradient-to-br from-[#4CD964] to-[#3DBF55] rounded-2xl p-6 text-white">
              <h2 class="text-lg font-semibold mb-4">How It Works</h2>
              <div class="space-y-4">
                <div class="flex items-start gap-3">
                  <div class="w-6 h-6 rounded-full bg-white/20 flex items-center justify-center flex-shrink-0">
                    <span class="text-xs font-bold">1</span>
                  </div>
                  <div>
                    <p class="font-medium">Start an Assessment</p>
                    <p class="text-sm text-white/80">Describe your AI project idea</p>
                  </div>
                </div>
                <div class="flex items-start gap-3">
                  <div class="w-6 h-6 rounded-full bg-white/20 flex items-center justify-center flex-shrink-0">
                    <span class="text-xs font-bold">2</span>
                  </div>
                  <div>
                    <p class="font-medium">Answer Questions</p>
                    <p class="text-sm text-white/80">AI guides you through 12 dimensions</p>
                  </div>
                </div>
                <div class="flex items-start gap-3">
                  <div class="w-6 h-6 rounded-full bg-white/20 flex items-center justify-center flex-shrink-0">
                    <span class="text-xs font-bold">3</span>
                  </div>
                  <div>
                    <p class="font-medium">Get Your Report</p>
                    <p class="text-sm text-white/80">Comprehensive suitability analysis</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
    """
  end

  # Stat card component
  attr :title, :string, required: true
  attr :value, :integer, required: true
  attr :icon, :string, required: true
  attr :color, :string, required: true

  defp stat_card(assigns) do
    icon_bg =
      case assigns.color do
        "blue" -> "bg-blue-100"
        "amber" -> "bg-amber-100"
        "green" -> "bg-green-100"
        "purple" -> "bg-purple-100"
        _ -> "bg-gray-100"
      end

    icon_color =
      case assigns.color do
        "blue" -> "text-blue-600"
        "amber" -> "text-amber-600"
        "green" -> "text-[#4CD964]"
        "purple" -> "text-purple-600"
        _ -> "text-gray-600"
      end

    assigns = assign(assigns, :icon_bg, icon_bg)
    assigns = assign(assigns, :icon_color, icon_color)

    ~H"""
    <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-6">
      <div class="flex items-center gap-4">
        <div class={"w-12 h-12 rounded-xl #{@icon_bg} flex items-center justify-center"}>
          <.stat_icon name={@icon} class={"w-6 h-6 #{@icon_color}"} />
        </div>
        <div>
          <p class="text-2xl font-bold text-gray-900">{@value}</p>
          <p class="text-sm text-gray-500">{@title}</p>
        </div>
      </div>
    </div>
    """
  end

  defp stat_icon(%{name: "clipboard-list"} = assigns) do
    ~H"""
    <svg class={@class} fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"
      />
    </svg>
    """
  end

  defp stat_icon(%{name: "refresh"} = assigns) do
    ~H"""
    <svg class={@class} fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"
      />
    </svg>
    """
  end

  defp stat_icon(%{name: "check-circle"} = assigns) do
    ~H"""
    <svg class={@class} fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
      />
    </svg>
    """
  end

  defp stat_icon(%{name: "document-text"} = assigns) do
    ~H"""
    <svg class={@class} fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
      />
    </svg>
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

  # PubSub handlers
  @impl true
  def handle_info({:session_updated, _session}, socket) do
    socket =
      socket
      |> load_stats()
      |> load_recent_sessions()

    {:noreply, socket}
  end

  @impl true
  def handle_info({:session_created, _session}, socket) do
    socket =
      socket
      |> load_stats()
      |> load_recent_sessions()

    {:noreply, socket}
  end

  # Private functions

  defp load_stats(socket) do
    user = socket.assigns.current_user
    sessions = Assessments.list_sessions(user.id)

    stats = %{
      total: length(sessions),
      in_progress: Enum.count(sessions, &(&1.status == :gathering)),
      completed: Enum.count(sessions, &(&1.status in [:ready_for_report, :report_generated])),
      reports: Enum.count(sessions, &(&1.status == :report_generated))
    }

    assign(socket, :stats, stats)
  end

  defp load_recent_sessions(socket) do
    user = socket.assigns.current_user
    sessions = Assessments.list_sessions(user.id) |> Enum.take(5)
    assign(socket, :recent_sessions, sessions)
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
