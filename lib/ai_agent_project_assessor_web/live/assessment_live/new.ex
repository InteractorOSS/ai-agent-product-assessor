defmodule AiAgentProjectAssessorWeb.AssessmentLive.New do
  @moduledoc """
  LiveView for creating a new assessment session.

  Simplified flow: Users enter only a project name, then add
  description and files on the Show page with auto-save.
  """

  use AiAgentProjectAssessorWeb, :live_view

  alias AiAgentProjectAssessor.Assessments

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "New Assessment")
      |> assign(:form, to_form(%{"name" => ""}, as: :assessment))
      |> assign(:submitting, false)
      |> assign(:selected_template, nil)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gray-50">
      <!-- Header -->
      <header class="bg-white border-b border-gray-200">
        <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <div class="flex items-center gap-4">
            <.link
              navigate={~p"/assessments"}
              class="text-gray-400 hover:text-gray-600 transition-colors"
            >
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M10 19l-7-7m0 0l7-7m-7 7h18"
                />
              </svg>
            </.link>
            <div>
              <h1 class="text-2xl font-semibold text-gray-900">New Assessment</h1>
              <p class="mt-1 text-sm text-gray-500">
                Start a new AI project assessment
              </p>
            </div>
          </div>
        </div>
      </header>
      
    <!-- Main Content -->
      <main class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="grid gap-8 lg:grid-cols-3">
          <!-- Form Section -->
          <div class="lg:col-span-2">
            <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-6">
              <.form for={@form} phx-submit="create" phx-change="validate" class="space-y-6">
                <!-- Project Name -->
                <div>
                  <label for="assessment_name" class="block text-sm font-medium text-gray-700 mb-2">
                    Project Name <span class="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="assessment[name]"
                    id="assessment_name"
                    value={@form[:name].value}
                    placeholder="e.g., Customer Support AI Agent"
                    required
                    autofocus
                    class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#4CD964] focus:border-transparent transition-colors text-gray-900"
                  />
                  <p class="mt-1 text-xs text-gray-500">
                    Give your project a descriptive name
                  </p>
                </div>
                
    <!-- Info about next steps -->
                <div class="bg-blue-50 rounded-xl p-4">
                  <div class="flex gap-3">
                    <svg
                      class="w-5 h-5 text-blue-600 flex-shrink-0 mt-0.5"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                      />
                    </svg>
                    <div class="text-sm text-blue-800">
                      <p class="font-medium mb-1">What happens next?</p>
                      <p>
                        After creating, you can add a description, upload documents, and
                        start chatting with the AI assistant. Everything auto-saves as you work.
                      </p>
                    </div>
                  </div>
                </div>
                
    <!-- Submit Button -->
                <div class="pt-2">
                  <button
                    type="submit"
                    disabled={@submitting || String.trim(@form[:name].value || "") == ""}
                    class="w-full flex items-center justify-center gap-2 px-6 py-3 bg-[#4CD964] hover:bg-[#3DBF55] disabled:bg-gray-300 disabled:cursor-not-allowed text-white font-medium rounded-full shadow-md transition-colors"
                  >
                    <%= if @submitting do %>
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
                      Creating...
                    <% else %>
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M13 10V3L4 14h7v7l9-11h-7z"
                        />
                      </svg>
                      Start Assessment
                    <% end %>
                  </button>
                </div>
              </.form>
            </div>
          </div>
          
    <!-- Templates Sidebar -->
          <div class="lg:col-span-1">
            <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-6">
              <h3 class="text-sm font-semibold text-gray-900 mb-4">Quick Start Templates</h3>
              <div class="space-y-3">
                <.template_card
                  id="customer_support"
                  title="Customer Support AI"
                  description="Automate customer inquiries and support tickets"
                  selected={@selected_template == "customer_support"}
                />
                <.template_card
                  id="document_processing"
                  title="Document Processing"
                  description="Extract and analyze information from documents"
                  selected={@selected_template == "document_processing"}
                />
                <.template_card
                  id="recommendation_engine"
                  title="Recommendation Engine"
                  description="Personalized recommendations for users"
                  selected={@selected_template == "recommendation_engine"}
                />
                <.template_card
                  id="data_analysis"
                  title="Data Analysis Agent"
                  description="Automated data analysis and insights"
                  selected={@selected_template == "data_analysis"}
                />
                <.template_card
                  id="content_generation"
                  title="Content Generation"
                  description="Generate marketing or product content"
                  selected={@selected_template == "content_generation"}
                />
              </div>
            </div>
            
    <!-- Tips Card -->
            <div class="mt-6 bg-blue-50 rounded-2xl p-6">
              <h3 class="text-sm font-semibold text-blue-900 mb-3">
                <svg
                  class="w-5 h-5 inline-block mr-1"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                  />
                </svg>
                Tips for a Better Assessment
              </h3>
              <ul class="text-sm text-blue-800 space-y-2">
                <li class="flex items-start gap-2">
                  <svg
                    class="w-4 h-4 mt-0.5 text-blue-600"
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
                  <span>Be specific about the problem you're solving</span>
                </li>
                <li class="flex items-start gap-2">
                  <svg
                    class="w-4 h-4 mt-0.5 text-blue-600"
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
                  <span>Mention any existing data sources</span>
                </li>
                <li class="flex items-start gap-2">
                  <svg
                    class="w-4 h-4 mt-0.5 text-blue-600"
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
                  <span>Include any technical constraints</span>
                </li>
                <li class="flex items-start gap-2">
                  <svg
                    class="w-4 h-4 mt-0.5 text-blue-600"
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
                  <span>Define success criteria if known</span>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </main>
    </div>
    """
  end

  # Template card component
  attr :id, :string, required: true
  attr :title, :string, required: true
  attr :description, :string, required: true
  attr :selected, :boolean, default: false

  defp template_card(assigns) do
    ~H"""
    <button
      type="button"
      phx-click="select_template"
      phx-value-template={@id}
      class={"w-full text-left p-3 rounded-xl border-2 transition-all #{if @selected, do: "border-[#4CD964] bg-green-50", else: "border-gray-200 hover:border-gray-300 hover:bg-gray-50"}"}
    >
      <h4 class="text-sm font-medium text-gray-900">{@title}</h4>
      <p class="mt-1 text-xs text-gray-500">{@description}</p>
    </button>
    """
  end

  # Event handlers

  @impl true
  def handle_event("validate", %{"assessment" => params}, socket) do
    form = to_form(params, as: :assessment)
    {:noreply, assign(socket, :form, form)}
  end

  @impl true
  def handle_event("select_template", %{"template" => template_id}, socket) do
    template = get_template(template_id)

    form = to_form(%{"name" => template.name}, as: :assessment)

    socket =
      socket
      |> assign(:form, form)
      |> assign(:selected_template, template_id)

    {:noreply, socket}
  end

  @impl true
  def handle_event("create", %{"assessment" => params}, socket) do
    name = String.trim(params["name"] || "")

    if name == "" do
      {:noreply, put_flash(socket, :error, "Project name is required")}
    else
      socket = assign(socket, :submitting, true)
      user = socket.assigns.current_user

      attrs = %{
        name: name,
        user_id: user.id,
        status: :gathering
      }

      case Assessments.create_session(attrs) do
        {:ok, session} ->
          # Notify about new session
          Phoenix.PubSub.broadcast(
            AiAgentProjectAssessor.PubSub,
            "user:#{user.id}:assessments",
            {:session_created, session}
          )

          socket =
            socket
            |> put_flash(:info, "Assessment created! Add project details and start chatting.")
            |> push_navigate(to: ~p"/assessments/#{session.id}")

          {:noreply, socket}

        {:error, changeset} ->
          socket =
            socket
            |> assign(:submitting, false)
            |> put_flash(:error, "Failed to create assessment: #{error_message(changeset)}")

          {:noreply, socket}
      end
    end
  end

  # Private functions

  defp get_template(id) do
    templates = %{
      "customer_support" => %{name: "Customer Support AI Agent"},
      "document_processing" => %{name: "Document Processing Agent"},
      "recommendation_engine" => %{name: "Personalized Recommendation Engine"},
      "data_analysis" => %{name: "Data Analysis Agent"},
      "content_generation" => %{name: "Content Generation System"}
    }

    Map.get(templates, id, %{name: ""})
  end

  defp error_message(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.map(fn {field, errors} -> "#{field}: #{Enum.join(errors, ", ")}" end)
    |> Enum.join("; ")
  end
end
