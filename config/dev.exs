import Config

# Configure your database
config :marker, Marker.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "marker_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with esbuild to bundle .js and .css sources.
config :marker, MarkerWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "/hAxfepkftWv3j5YUKw+RkMKvGAs1w/Q4IwjylE2XDJ5jI34UaSejlgwP3R1JV2D",
  watchers: [
    # Start the esbuild watcher by calling Esbuild.install_and_run(:default, args)
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    # Tailwind (see https://tailwindcss.com/docs/guides/phoenix)
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]}
  ]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :marker, MarkerWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/marker_web/(live|views)/.*(ex)$",
      ~r"lib/marker_web/templates/.*(eex)$"
    ]
  ]

# Do not include timestamps in development logs
config :logger, :console,
  format: "[$level] $message\n     ($metadata)\n",
  metadata: [:mfa, :file, :line, :registered_name]

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Relax Password Requirements in Dev environment for convenience
config :marker, Marker.Accounts,
  min_password_length: 1,
  login_with_any_password: true

# Archival Backends
config :marker, Marker.Archive,
  enabled_backends: [
    # :shiori
  ]

config :marker, Marker.Archive.Shiori,
  address: "localhost:50001",
  username: "shiori",
  password: "gopher"
