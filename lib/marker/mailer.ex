defmodule Marker.Mailer do
  use Boundary

  use Swoosh.Mailer, otp_app: :marker
end
