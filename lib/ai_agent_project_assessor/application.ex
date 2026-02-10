defmodule AiAgentProjectAssessor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AiAgentProjectAssessorWeb.Telemetry,
      AiAgentProjectAssessor.Repo,
      {DNSCluster,
       query: Application.get_env(:ai_agent_project_assessor, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AiAgentProjectAssessor.PubSub},
      # Background job processing with Oban
      {Oban, Application.fetch_env!(:ai_agent_project_assessor, Oban)},
      # Interactor setup - creates/verifies AI assistant on startup
      AiAgentProjectAssessor.InteractorSetup,
      # Start to serve requests, typically the last entry
      AiAgentProjectAssessorWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AiAgentProjectAssessor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AiAgentProjectAssessorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
