import Config

import_config "../../config/config.exs"

config :zone_meal_tracker_web, ZoneMealTrackerWeb.Endpoint,
  code_reloader: false,
  server: true

# Configure your database
config :zone_meal_tracker, ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl.Repo,
  database: "zone_meal_tracker_integration_test"

# Configure your database
config :zmt_notifications,
       ZMTNotifications.DefaultImpl.NotificationPreferenceStore.PostgresImpl.Repo,
       database: "zone_meal_tracker_integration_test"

config :integration_tester,
  ecto_repos: [
    ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl.Repo,
    ZMTNotifications.DefaultImpl.NotificationPreferenceStore.PostgresImpl.Repo
  ]

config :wallaby,
  driver: Wallaby.Experimental.Chrome
