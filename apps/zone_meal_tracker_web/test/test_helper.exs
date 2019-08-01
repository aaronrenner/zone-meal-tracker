Mox.defmock(ZoneMealTrackerWeb.MockZoneMealTracker, for: ZoneMealTracker.Impl)

Application.put_env(:zone_meal_tracker, :impl, ZoneMealTrackerWeb.MockZoneMealTracker)

ExUnit.start()
