defmodule AiAgentProjectAssessorWeb.Router do
  use AiAgentProjectAssessorWeb, :router

  import AiAgentProjectAssessorWeb.Plugs.Auth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AiAgentProjectAssessorWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Public routes (no auth required)
  scope "/", AiAgentProjectAssessorWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Authentication routes
  scope "/", AiAgentProjectAssessorWeb do
    pipe_through [:browser, :redirect_if_authenticated]

    live_session :redirect_if_authenticated,
      on_mount: [{AiAgentProjectAssessorWeb.LiveHelpers, :redirect_if_authenticated}] do
      live "/login", LoginLive, :index
    end
  end

  scope "/auth", AiAgentProjectAssessorWeb do
    pipe_through :browser

    get "/interactor", AuthController, :login
    get "/interactor/callback", AuthController, :callback
    delete "/logout", AuthController, :logout
    post "/dev-login", AuthController, :dev_login
  end

  # Protected routes (requires authentication)
  scope "/", AiAgentProjectAssessorWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{AiAgentProjectAssessorWeb.LiveHelpers, :require_authenticated_user}] do
      # Dashboard
      live "/dashboard", DashboardLive, :index

      # Assessment management
      live "/assessments", AssessmentLive.Index, :index
      live "/assessments/new", AssessmentLive.New, :new
      live "/assessments/:id", AssessmentLive.Show, :show

      # Report management
      live "/reports/:id", ReportLive.Show, :show
    end
  end

  # API routes
  scope "/api", AiAgentProjectAssessorWeb do
    pipe_through :api

    # Webhooks from Interactor
    post "/webhooks/interactor", WebhookController, :handle
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ai_agent_project_assessor, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AiAgentProjectAssessorWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
