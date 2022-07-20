[
  plugins: [Phoenix.LiveView.HTMLFormatter],
  import_deps: [:ecto, :phoenix],
  inputs: ["*.{heex,ex,exs}", "priv/*/seeds.exs", "{config,lib,test}/**/*.{heex,ex,exs}"],
  subdirectories: ["priv/*/migrations"],
  # Note this doesn't apply to subdirectories. See https://stackoverflow.com/questions/59535671/elixirs-mix-format-ignores-line-length-option.
  line_length: 120
]
