defmodule ZMTNotifications.DefaultImpl.NotificationPreferenceStore.PostgresImpl.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :zmt_notifications,
    adapter: Ecto.Adapters.Postgres
end
