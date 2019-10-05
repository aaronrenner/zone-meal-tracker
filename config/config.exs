# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configures the endpoint
config :zone_meal_tracker_web, ZoneMealTrackerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Eyi3LcZnkb4PU13uyDjMxQXFtEChAQD6jHnw50gxqKmWDXvn0M1VIb/va9s9NiNy",
  render_errors: [view: ZoneMealTrackerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ZoneMealTrackerWeb.PubSub, adapter: Phoenix.PubSub.PG2]

config :zone_meal_tracker,
  ecto_repos: [
    ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl.Repo,
    ZMTNotifications.DefaultImpl.NotificationPreferenceStore.PostgresImpl.Repo
  ]

config :zone_meal_tracker, ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl.Repo,
  priv: "priv/account_store/postgres_impl/repo"

config :zmt_notifications,
  ecto_repos: [
    ZMTNotifications.DefaultImpl.NotificationPreferenceStore.PostgresImpl.Repo
  ]

config :zmt_notifications,
       ZMTNotifications.DefaultImpl.NotificationPreferenceStore.PostgresImpl.Repo,
       priv: "priv/notifications/default_impl/notification_preference_store/postgres_impl/repo"

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]
#

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
