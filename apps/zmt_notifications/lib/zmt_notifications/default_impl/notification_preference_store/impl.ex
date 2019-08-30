defmodule ZMTNotifications.DefaultImpl.NotificationPreferenceStore.Impl do
  @moduledoc false

  alias ZMTNotifications.DefaultImpl.NotificationPreferenceStore

  @type user_id :: String.t()
  @type email :: String.t()

  @callback put_primary_email(user_id, email) :: :ok | {:error, :invalid_user_id}
  @callback fetch_primary_email(user_id) :: {:ok, email} | {:error, :not_found}
  @callback reset([NotificationPreferenceStore.reset_opt()]) :: :ok
end
