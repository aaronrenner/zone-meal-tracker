use Mix.Config

config :zone_meal_tracker_web, ZoneMealTrackerWeb.Endpoint, http: [:inet6]

# Configure your database
config :zone_meal_tracker, ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl.Repo,
  username: "postgres",
  password: "postgres",
  database: "zone_meal_tracker_prod",
  hostname: "localhost",
  pool_size: 10

# Configure your database
config :zmt_notifications,
       ZMTNotifications.DefaultImpl.NotificationPreferenceStore.PostgresImpl.Repo,
       username: "postgres",
       password: "postgres",
       database: "zone_meal_tracker_prod",
       hostname: "localhost",
       pool_size: 10

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :zone_meal_tracker_web, ZoneMealTrackerWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
