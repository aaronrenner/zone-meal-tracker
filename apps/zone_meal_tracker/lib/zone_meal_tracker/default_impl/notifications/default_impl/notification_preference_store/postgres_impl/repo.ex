defmodule ZoneMealTracker.DefaultImpl.Notifications.DefaultImpl.NotificationPreferenceStore.PostgresImpl.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :zone_meal_tracker,
    adapter: Ecto.Adapters.Postgres
end
