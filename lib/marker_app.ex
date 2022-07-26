defmodule MarkerApp do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Boundary,
    deps: [Marker, MarkerWeb],
    # We suppress alias checking here since we need to specify supervisors like
    # `Marker.Repo`. Note that exporting Marker.Repo would be undesireable,
    # as this would allow unrestricted access to the database. We'd rather
    # relax the check here than do it globally.
    check: [aliases: false]

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
      MarkerWeb.Endpoint,
      # Start a worker by calling: Marker.Worker.start_link(arg)
      # {Marker.Worker, arg}
      Marker.Archive.Supervisor
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
