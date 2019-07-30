IntegrationTester.start_zone_meal_tracker_web()

{:ok, _} = Application.ensure_all_started(:wallaby)

Application.put_env(:wallaby, :base_url, ZoneMealTrackerWeb.Endpoint.url())

ExUnit.start()
