use Mix.Config

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

live_view_signing_salt =
  System.get_env("LIVE_VIEW_SIGNING_SALT") ||
    raise """
    environment variable LIVE_VIEW_SIGNING_SALT is missing.
    You can generate one by calling: mix phx.gen.secret 32
    """

config :zone_meal_tracker_web, ZoneMealTrackerWeb.Endpoint,
  http: [:inet6, port: String.to_integer(System.get_env("PORT") || "4000")],
  secret_key_base: secret_key_base,
  live_view: [
    signing_salt = live_view_signing_salt
  ]

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
