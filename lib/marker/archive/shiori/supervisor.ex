defmodule Marker.Archive.Shiori.Supervisor do
  @moduledoc """
  OTP Supervisor for Shiori Archive Service.
  """
  use Supervisor

  alias Marker.Archive.Shiori.{Cache, Server}

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    children = [
      {Cache, [nil]},
      {Server, [nil]}
    ]

    # We kill the cache if Server panics since it may fail to update the cache!
    Supervisor.init(children, strategy: :one_for_all)
  end
end
