defmodule FindStatePlates.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FindStatePlatesWeb.Telemetry,
      FindStatePlates.Repo,
      {DNSCluster, query: Application.get_env(:find_state_plates, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FindStatePlates.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FindStatePlates.Finch},
      # Start a worker by calling: FindStatePlates.Worker.start_link(arg)
      # {FindStatePlates.Worker, arg},
      # Start to serve requests, typically the last entry
      FindStatePlatesWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FindStatePlates.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FindStatePlatesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
