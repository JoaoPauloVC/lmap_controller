defmodule LmapController.Application do
  # See https://elixir.hexdocs.pm/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LmapControllerWeb.Telemetry,
      LmapController.Repo,
      {DNSCluster, query: Application.get_env(:lmap_controller, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LmapController.PubSub},
      # Start a worker by calling: LmapController.Worker.start_link(arg)
      # {LmapController.Worker, arg},
      # Start to serve requests, typically the last entry
      LmapControllerWeb.Endpoint
    ]

    # See https://elixir.hexdocs.pm/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LmapController.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LmapControllerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
