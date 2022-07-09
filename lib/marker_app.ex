defmodule MarkerApp do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Boundary, deps: [Marker, MarkerWeb]

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Marker.Repo,
      # Start the Telemetry supervisor
      MarkerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Marker.PubSub},
      # Start the Endpoint (http/https)
      MarkerWeb.Endpoint
      # Start a worker by calling: Marker.Worker.start_link(arg)
      # {Marker.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Marker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MarkerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
