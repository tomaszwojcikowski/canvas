# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :canvas,
  ecto_repos: [Canvas.Repo]

# Configures the endpoint
config :canvas, CanvasWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: CanvasWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Canvas.PubSub,
  live_view: [signing_salt: "po470bdJ"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :canvas, Canvas.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason


config :canvas, Canvas.Repo,
  username: {:system, :string, "POSTGRES_DB_USER"},
  password: {:system, :string, "POSTGRES_DB_PASSWORD"},
  database: {:system, :string, "POSTGRES_DB_NAME"},
  hostname: {:system, :string, "POSTGRES_DB_HOST"}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
