# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :data_monitor, ecto_repos: [DataMonitor.Repo]

# Configures the endpoint
config :data_monitor, DataMonitor.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "d3HCFhsVBlmUHsFkcDl8EDwp9ZRtBuyoEwSzGtKXqT8bEsEl5daidQIv/0epI1xv",
  render_errors: [view: DataMonitor.ErrorView, accepts: ~w(html json)],
  pubsub: [name: DataMonitor.PubSub, adapter: Phoenix.PubSub.PG2],
  core_engine_host: "http://core-engine-api",
  core_engine_port: "80",
  core_engine_prefix: "api/v2",
  core_engine: DataMonitor.CoreEngineRemote,
  auth_headers: [
    {"x-seneca-email", "dev_robot@bar.com"},
    {"x-cpat-charge-code", "CC12345"},
    {"authorization",
     "Bearer eyJhbGciOiJIUzI1NiJ9.eyJuaWNrbmFtZSI6ImRldl9yb2JvdCIsImlhdCI6MTUyMjY4NTQxOH0.VMOG6KEDNVAVzmegXR5jJjl9Guc5nqAdiGzcg81UBrI"}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :data_monitor, DataMonitor.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: "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"

config :data_monitor, DataMonitor.Scheduler,
  jobs: [
    # Every minute
    # {"* * * * *", {DataMonitor.RuleSender, :perform, []}}
    # # Every 15 minutes
    # {"*/15 * * * *", {DataMonitor.RuleSender, :perform, []}}
    # # Runs on 18, 20, 22, 0, 2, 4, 6:
    # {"0 18-6/2 * * *", fn -> :mnesia.backup('/var/backup/mnesia') end},
    # # Runs every midnight:
    {"@daily", {DataMonitor.RuleSender, :perform, []}}
  ]
