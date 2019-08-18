Mox.defmock(ZoneMealTrackerWeb.MockZoneMealTracker, for: ZoneMealTracker.Impl)

Application.put_env(:zone_meal_tracker, :impl, ZoneMealTrackerWeb.MockZoneMealTracker)

Mox.defmock(ZoneMealTrackerWeb.MockAuthentication, for: ZoneMealTrackerWeb.Authentication.Impl)

Application.put_env(
  :zone_meal_tracker_web,
  :authentication_impl,
  ZoneMealTrackerWeb.MockAuthentication
)

ExUnit.start()
