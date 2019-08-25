defmodule ZoneMealTracker.DefaultImpl.Notifications.DefaultImpl.Emails.Guards do
  @moduledoc false

  defguard is_email(term) when is_binary(term)
end
