defmodule AiAgentProjectAssessorWeb.LoginLive do
  @moduledoc """
  LiveView for user authentication.

  Supports two authentication modes:
  1. Interactor OAuth - Redirects to Interactor auth server
  2. Development mode - Simple email-based login (dev only)
  """

  use AiAgentProjectAssessorWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    dev_mode? = Application.get_env(:ai_agent_project_assessor, :dev_routes, false)

    socket =
      socket
      |> assign(:dev_mode?, dev_mode?)
      |> assign(:error, nil)
      |> assign(:page_title, "Log In")

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div class="max-w-md w-full space-y-8">
        <div>
          <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
            AI Agent Project Assessor
          </h2>
          <p class="mt-2 text-center text-sm text-gray-600">
            Sign in to continue
          </p>
        </div>

        <%= if @error do %>
          <div class="rounded-md bg-red-50 p-4">
            <div class="flex">
              <div class="ml-3">
                <h3 class="text-sm font-medium text-red-800">
                  {@error}
                </h3>
              </div>
            </div>
          </div>
        <% end %>

        <div class="mt-8 space-y-6">
          <!-- Interactor OAuth Login -->
          <div>
            <a
              href="/auth/interactor"
              class="group relative w-full flex justify-center py-3 px-4 border border-transparent text-sm font-medium rounded-full text-white bg-[#4CD964] hover:bg-[#3DBF55] focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500"
            >
              Sign in with Interactor
            </a>
          </div>

          <%= if @dev_mode? do %>
            <div class="relative">
              <div class="absolute inset-0 flex items-center">
                <div class="w-full border-t border-gray-300"></div>
              </div>
              <div class="relative flex justify-center text-sm">
                <span class="px-2 bg-gray-50 text-gray-500">Or continue with email (dev only)</span>
              </div>
            </div>

            <form action="/auth/dev-login" method="post" class="mt-6 space-y-4">
              <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
              <div>
                <label for="email" class="sr-only">Email address</label>
                <input
                  type="email"
                  name="email"
                  id="email"
                  required
                  class="appearance-none rounded-lg relative block w-full px-3 py-3 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-green-500 focus:border-green-500 sm:text-sm"
                  placeholder="Email address"
                />
              </div>
              <button
                type="submit"
                class="group relative w-full flex justify-center py-3 px-4 border border-gray-300 text-sm font-medium rounded-full text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500"
              >
                Continue (Dev Mode)
              </button>
            </form>
          <% end %>
        </div>

        <div class="mt-6 text-center">
          <p class="text-sm text-gray-600">
            New to AI Project Assessor?
            <a href="#" class="font-medium text-[#4CD964] hover:text-[#3DBF55]">
              Learn more about our assessment methodology
            </a>
          </p>
        </div>
      </div>
    </div>
    """
  end
end
