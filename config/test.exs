import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :marker, Marker.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "marker_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :marker, MarkerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "yVeoNIwfLYPs8ysDou5+bgYqq7REYLw6Js3RZaQmbCeSE4hOKb7Lcn4KCzUxHtjx",
  server: false

# In test we don't send emails.
config :marker, Marker.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Archival Backends
config :marker, Marker.Archive,
  enabled_backends: [
    # :shiori
  ]

# Must start a new shiori server to run any tests that use the shiori backend.
config :marker, Marker.Archive.Shiori,
  address: "localhost:50002",
  username: "shiori",
  password: "gopher"
