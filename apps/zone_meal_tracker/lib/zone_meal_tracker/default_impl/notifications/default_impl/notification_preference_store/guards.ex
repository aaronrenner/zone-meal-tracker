defmodule ZoneMealTracker.DefaultImpl.Notifications.DefaultImpl.NotificationPreferenceStore.Guards do
  @moduledoc false

  defguard is_user_id(term) when is_binary(term)
  defguard is_email(term) when is_binary(term)
end
