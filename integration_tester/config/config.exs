import Config

import_config "../../config/config.exs"

config :zone_meal_tracker_web, ZoneMealTrackerWeb.Endpoint,
  code_reloader: false,
  server: true

config :wallaby,
  driver: Wallaby.Experimental.Chrome
