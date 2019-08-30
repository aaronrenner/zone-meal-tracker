defmodule ZMTNotifications.DefaultImpl.Emails.Impl do
  @moduledoc false

  @type email :: String.t()

  @callback send_welcome_email(email) :: :ok
end
