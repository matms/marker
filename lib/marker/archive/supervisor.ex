defmodule Marker.Archive.Supervisor do
  @moduledoc """
  OTP Supervisor for all archival backends.
  """
  use Supervisor

  alias Marker.Archive.Shiori

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    children =
      maybe_backend(:shiori, [nil]) ++
        []

    Supervisor.init(children, strategy: :one_for_one)
  end

  # Returns an empty list if `backend` is inactive, and a list containing
  # the child spec of the relevant backend if it is active.
  #
  # Note: Active or inactive backends are specified by application configs,
  # see `backend_active?/1`.
  defp maybe_backend(:shiori, args) do
    if backend_active?(:shiori) do
      [{Shiori.Supervisor, args}]
    else
      []
    end
  end

  defp backend_active?(backend) when is_atom(backend) do
    Enum.member?(
      Application.get_env(:marker, Marker.Archive)[:enabled_backends],
      backend
    )
  end
end
