import Config

secret_key_base =
  System.get_env("ZMT_SECRET_KEY_BASE") ||
    raise """
    environment variable ZMT_SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

http_port_number =
  case System.fetch_env("ZMT_HTTP_PORT") do
    {:ok, port_str} ->
      {port_number, ""} = Integer.parse(port_str)
      port_number

    :error ->
      4000
  end

config :zone_meal_tracker_web, ZoneMealTrackerWeb.Endpoint,
  http: [port: http_port_number],
  secret_key_base: secret_key_base

case System.fetch_env("ZMT_DATABASE_URL") do
  {:ok, database_url} ->
    # Configure your database
    config :zone_meal_tracker, ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl.Repo,
      url: database_url

    # Configure your database
    config :zmt_notifications,
           ZMTNotifications.DefaultImpl.NotificationPreferenceStore.PostgresImpl.Repo,
           database_url: database_url

  :error ->
    nil
end
