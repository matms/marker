defmodule Marker.Repo do
  use Boundary

  use Ecto.Repo,
    otp_app: :marker,
    adapter: Ecto.Adapters.Postgres
end
