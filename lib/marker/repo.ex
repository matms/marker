defmodule Marker.Repo do
  use Ecto.Repo,
    otp_app: :marker,
    adapter: Ecto.Adapters.Postgres
end
