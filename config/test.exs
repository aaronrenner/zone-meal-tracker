use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :zone_meal_tracker_web, ZoneMealTrackerWeb.Endpoint,
  http: [port: 4002],
  server: false

# Configure your database
config :zone_meal_tracker, ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl.Repo,
  username: "postgres",
  password: "postgres",
  database: "zone_meal_tracker_test",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Configure your database
config :zmt_notifications,
       ZMTNotifications.DefaultImpl.NotificationPreferenceStore.PostgresImpl.Repo,
       username: "postgres",
       password: "postgres",
       database: "zone_meal_tracker_test",
       hostname: System.get_env("POSTGRES_HOST") || "localhost",
       pool: Ecto.Adapters.SQL.Sandbox

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8

config :zmt_notifications,
       ZMTNotifications.DefaultImpl.Emails.BambooImpl.Mailer,
       adapter: Bamboo.TestAdapter
