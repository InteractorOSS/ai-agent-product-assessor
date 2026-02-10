defmodule AiAgentProjectAssessorWeb.ReportLive.Show do
  @moduledoc """
  LiveView for viewing and editing assessment reports.

  Features:
  - Section navigation sidebar
  - Rich text editing with TipTap
  - Auto-save functionality
  - Version history access
  """

  use AiAgentProjectAssessorWeb, :live_view

  alias AiAgentProjectAssessor.Reports
  alias AiAgentProjectAssessor.ReportGenerator

  @auto_save_interval 30_000

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    report = Reports.get_report_with_preloads!(id)

    if connected?(socket) do
      # Subscribe to report updates
      Phoenix.PubSub.subscribe(AiAgentProjectAssessor.PubSub, "report:#{id}")
      # Schedule auto-save
      Process.send_after(self(), :auto_save, @auto_save_interval)
    end

    socket =
      socket
      |> assign(:report, report)
      |> assign(:active_section, List.first(report.section_order))
      |> assign(:editing, false)
      |> assign(:unsaved_changes, false)
      |> assign(:saving, false)
      |> assign(:exporting, nil)
      |> assign(:show_export_menu, false)
      |> assign(:page_title, "Report: #{report.session.name || "Report"}")

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex h-screen bg-gray-50">
      <!-- Section Navigation Sidebar -->
      <aside class="w-64 bg-white border-r border-gray-200 flex flex-col">
        <div class="p-4 border-b border-gray-200">
          <h2 class="text-lg font-semibold text-gray-800">Report Sections</h2>
          <p class="text-sm text-gray-500 mt-1">
            Score:
            <span class="font-medium text-[#4CD964]">{round(@report.suitability_score || 0)}%</span>
          </p>
        </div>

        <nav class="flex-1 overflow-y-auto p-2">
          <%= for section <- @report.section_order do %>
            <button
              phx-click="select_section"
              phx-value-section={section}
              class={"w-full text-left px-3 py-2 rounded-lg text-sm transition-colors #{if @active_section == section, do: "bg-[#4CD964] text-white", else: "text-gray-700 hover:bg-gray-100"}"}
            >
              {ReportGenerator.section_title(section)}
            </button>
          <% end %>
        </nav>

        <div class="p-4 border-t border-gray-200 space-y-2">
          <!-- Export Dropdown -->
          <div class="relative">
            <button
              phx-click="toggle_export_menu"
              disabled={@exporting != nil}
              class="w-full flex items-center justify-center gap-2 px-4 py-2 bg-[#4CD964] hover:bg-[#3DBF55] disabled:bg-gray-300 disabled:cursor-not-allowed text-white rounded-full text-sm font-medium transition-colors"
            >
              <%= if @exporting do %>
                <svg class="animate-spin w-4 h-4" fill="none" viewBox="0 0 24 24">
                  <circle
                    class="opacity-25"
                    cx="12"
                    cy="12"
                    r="10"
                    stroke="currentColor"
                    stroke-width="4"
                  />
                  <path
                    class="opacity-75"
                    fill="currentColor"
                    d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                  />
                </svg>
                Exporting {@exporting}...
              <% else %>
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                  />
                </svg>
                Export
                <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M19 9l-7 7-7-7"
                  />
                </svg>
              <% end %>
            </button>

            <%= if @show_export_menu do %>
              <div class="absolute bottom-full left-0 right-0 mb-2 bg-white rounded-xl shadow-lg border border-gray-200 overflow-hidden z-10">
                <button
                  phx-click="export"
                  phx-value-format="pdf"
                  class="w-full flex items-center gap-3 px-4 py-3 hover:bg-gray-50 text-sm text-gray-700"
                >
                  <svg class="w-5 h-5 text-red-500" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8l-6-6zm-1 2l5 5h-5V4zm-2.5 9.5a1 1 0 01-1 1H9v2H7.5v-6H10a1.5 1.5 0 011.5 1.5v1.5zm4 2.5h-2v-6h2a2 2 0 012 2v2a2 2 0 01-2 2zm5-4.5h-1.5V13h1v1.5h-1V16h-1.5v-6H19v1.5z" />
                  </svg>
                  PDF Document
                </button>
                <button
                  phx-click="export"
                  phx-value-format="docx"
                  class="w-full flex items-center gap-3 px-4 py-3 hover:bg-gray-50 text-sm text-gray-700"
                >
                  <svg class="w-5 h-5 text-blue-500" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8l-6-6zm4 18H6V4h7v5h5v11zm-9.5-5L7 10h1.5l1 3.5 1-3.5H12l-1.5 5h-1.5l-.5-1.5-.5 1.5H6.5z" />
                  </svg>
                  Word Document
                </button>
                <button
                  phx-click="export"
                  phx-value-format="html"
                  class="w-full flex items-center gap-3 px-4 py-3 hover:bg-gray-50 text-sm text-gray-700"
                >
                  <svg class="w-5 h-5 text-orange-500" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M12 17.56l-7.33 3.85 1.4-8.17L0 7.39l8.19-1.19L12 0l3.81 6.2L24 7.39l-6.07 5.85 1.4 8.17z" />
                  </svg>
                  HTML Page
                </button>
                <button
                  phx-click="export"
                  phx-value-format="markdown"
                  class="w-full flex items-center gap-3 px-4 py-3 hover:bg-gray-50 text-sm text-gray-700"
                >
                  <svg class="w-5 h-5 text-gray-600" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M22.27 19.385H1.73A1.73 1.73 0 010 17.655V6.345a1.73 1.73 0 011.73-1.73h20.54A1.73 1.73 0 0124 6.345v11.308a1.73 1.73 0 01-1.73 1.732zM5.769 15.923v-4.5l2.308 2.885 2.307-2.885v4.5h2.308V8.077h-2.308l-2.307 2.885-2.308-2.885H3.461v7.847h2.308zM21.232 12h-2.309V8.077h-2.307V12h-2.308l3.462 4.615z" />
                  </svg>
                  Markdown
                </button>
              </div>
            <% end %>
          </div>

          <button
            phx-click="show_versions"
            class="w-full flex items-center justify-center gap-2 px-4 py-2 border border-gray-300 text-gray-700 hover:bg-gray-50 rounded-full text-sm font-medium transition-colors"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"
              />
            </svg>
            Version History
          </button>

          <.link
            navigate={~p"/assessments/#{@report.session_id}"}
            class="w-full flex items-center justify-center gap-2 px-4 py-2 text-gray-500 hover:text-gray-700 text-sm"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M10 19l-7-7m0 0l7-7m-7 7h18"
              />
            </svg>
            Back to Assessment
          </.link>
        </div>
      </aside>
      
    <!-- Main Content Area -->
      <main class="flex-1 flex flex-col overflow-hidden">
        <!-- Header -->
        <header class="bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
          <div>
            <h1 class="text-xl font-semibold text-gray-800">
              {ReportGenerator.section_title(@active_section)}
            </h1>
            <%= if @unsaved_changes do %>
              <p class="text-sm text-amber-600">Unsaved changes</p>
            <% end %>
          </div>
          <div class="flex items-center gap-3">
            <%= if @saving do %>
              <span class="text-sm text-gray-500">Saving...</span>
            <% end %>
            <button
              phx-click="toggle_edit"
              class={"px-4 py-2 rounded-full text-sm font-medium transition-colors #{if @editing, do: "bg-gray-200 text-gray-800", else: "bg-[#4CD964] hover:bg-[#3DBF55] text-white"}"}
            >
              {if @editing, do: "Done Editing", else: "Edit Section"}
            </button>
          </div>
        </header>
        
    <!-- Editor/Viewer Area -->
        <div class="flex-1 overflow-y-auto p-6">
          <div class="max-w-4xl mx-auto">
            <%= if @editing do %>
              <div
                id="tiptap-editor"
                phx-hook="TipTapEditor"
                phx-update="ignore"
                data-section={@active_section}
                data-content={get_section_content(@report, @active_section)}
                class="prose prose-lg max-w-none min-h-[400px] bg-white rounded-2xl shadow-sm border border-gray-200 p-6"
              >
                <!-- TipTap will mount here -->
              </div>
            <% else %>
              <div class="prose prose-lg max-w-none bg-white rounded-2xl shadow-sm border border-gray-200 p-6">
                {raw(render_markdown(get_section_content(@report, @active_section)))}
              </div>
            <% end %>
          </div>
        </div>
      </main>
      
    <!-- Version History Modal -->
      <%= if assigns[:show_versions] do %>
        <.modal id="versions-modal" show on_cancel={JS.push("hide_versions")}>
          <div class="p-4">
            <h3 class="text-lg font-semibold mb-4">Version History</h3>
            <div class="space-y-2 max-h-96 overflow-y-auto">
              <%= for version <- @versions do %>
                <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                  <div>
                    <p class="font-medium">Version {version.version_number}</p>
                    <p class="text-sm text-gray-500">
                      {Calendar.strftime(version.inserted_at, "%b %d, %Y %H:%M")}
                    </p>
                    <%= if version.description do %>
                      <p class="text-sm text-gray-600">{version.description}</p>
                    <% end %>
                  </div>
                  <button
                    phx-click="restore_version"
                    phx-value-id={version.id}
                    class="text-sm text-[#4CD964] hover:underline"
                  >
                    Restore
                  </button>
                </div>
              <% end %>
            </div>
          </div>
        </.modal>
      <% end %>
    </div>
    """
  end

  @impl true
  def handle_event("select_section", %{"section" => section}, socket) do
    {:noreply, assign(socket, :active_section, section)}
  end

  @impl true
  def handle_event("toggle_edit", _params, socket) do
    {:noreply, assign(socket, :editing, !socket.assigns.editing)}
  end

  @impl true
  def handle_event("content_changed", %{"content" => content, "section" => section}, socket) do
    # Update report content in memory
    report = socket.assigns.report
    updated_content = Map.put(report.content, section, content)
    updated_report = %{report | content: updated_content}

    socket =
      socket
      |> assign(:report, updated_report)
      |> assign(:unsaved_changes, true)

    {:noreply, socket}
  end

  @impl true
  def handle_event("save", _params, socket) do
    save_report(socket)
  end

  @impl true
  def handle_event("toggle_export_menu", _params, socket) do
    {:noreply, assign(socket, :show_export_menu, !socket.assigns.show_export_menu)}
  end

  @impl true
  def handle_event("export", %{"format" => format}, socket) do
    report = socket.assigns.report
    user = socket.assigns.current_user

    # Enqueue export job with user_id for notifications
    AiAgentProjectAssessor.Workers.ExportWorker.enqueue(
      report.id,
      String.to_atom(format),
      user_id: user.id
    )

    format_name = format_display_name(format)

    socket =
      socket
      |> assign(:exporting, format_name)
      |> assign(:show_export_menu, false)
      |> put_flash(:info, "#{format_name} export started. You'll be notified when it's ready.")

    {:noreply, socket}
  end

  @impl true
  def handle_event("show_versions", _params, socket) do
    versions = Reports.list_versions(socket.assigns.report.id)

    socket =
      socket
      |> assign(:show_versions, true)
      |> assign(:versions, versions)

    {:noreply, socket}
  end

  @impl true
  def handle_event("hide_versions", _params, socket) do
    {:noreply, assign(socket, :show_versions, false)}
  end

  @impl true
  def handle_event("restore_version", %{"id" => version_id}, socket) do
    report = socket.assigns.report

    case Reports.restore_version(report, version_id) do
      {:ok, updated_report} ->
        socket =
          socket
          |> assign(:report, Reports.get_report_with_preloads!(updated_report.id))
          |> assign(:show_versions, false)
          |> put_flash(:info, "Version restored successfully")

        {:noreply, socket}

      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Failed to restore version")}
    end
  end

  @impl true
  def handle_info(:auto_save, socket) do
    socket =
      if socket.assigns.unsaved_changes do
        case do_save(socket) do
          {:ok, updated_socket} -> updated_socket
          _ -> socket
        end
      else
        socket
      end

    # Schedule next auto-save
    Process.send_after(self(), :auto_save, @auto_save_interval)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:report_updated, report}, socket) do
    {:noreply, assign(socket, :report, report)}
  end

  @impl true
  def handle_info({:export_complete, export}, socket) do
    socket =
      socket
      |> assign(:exporting, nil)
      |> put_flash(
        :info,
        "Export ready! Your #{format_display_name(to_string(export.format))} is ready for download."
      )

    {:noreply, socket}
  end

  # Private functions

  defp save_report(socket) do
    case do_save(socket) do
      {:ok, updated_socket} ->
        {:noreply, put_flash(updated_socket, :info, "Report saved")}

      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Failed to save report")}
    end
  end

  defp do_save(socket) do
    socket = assign(socket, :saving, true)
    report = socket.assigns.report

    # Create version before saving
    Reports.create_version(report, %{description: "Auto-save"})

    case Reports.update_report(report, %{content: report.content}) do
      {:ok, updated_report} ->
        socket =
          socket
          |> assign(:report, updated_report)
          |> assign(:unsaved_changes, false)
          |> assign(:saving, false)

        {:ok, socket}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp get_section_content(report, section) do
    Map.get(report.content || %{}, section, "")
  end

  defp render_markdown(content) do
    # Simple markdown rendering - in production use a proper library
    content
    |> String.replace(~r/^## (.+)$/m, "<h2>\\1</h2>")
    |> String.replace(~r/^### (.+)$/m, "<h3>\\1</h3>")
    |> String.replace(~r/^#### (.+)$/m, "<h4>\\1</h4>")
    |> String.replace(~r/\*\*(.+?)\*\*/, "<strong>\\1</strong>")
    |> String.replace(~r/\*(.+?)\*/, "<em>\\1</em>")
    |> String.replace(~r/^- (.+)$/m, "<li>\\1</li>")
    |> String.replace(~r/(<li>.+<\/li>\n?)+/, "<ul>\\0</ul>")
    |> String.replace(~r/\n\n/, "</p><p>")
    |> then(&"<p>#{&1}</p>")
  end

  defp format_display_name("pdf"), do: "PDF"
  defp format_display_name("docx"), do: "Word"
  defp format_display_name("html"), do: "HTML"
  defp format_display_name("markdown"), do: "Markdown"
  defp format_display_name(other), do: String.upcase(other)
end
