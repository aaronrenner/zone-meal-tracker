defmodule ZMTNotifications.Impl do
  @moduledoc false

  @type email :: String.t()
  @type user_id :: String.t()

  @callback set_user_email(user_id, email) :: :ok | {:error, :invalid_user_id}
  @callback send_welcome_message(user_id) :: :ok | {:error, :unknown_user_id}
  @callback reset([ZMTNotifications.reset_opt()]) :: :ok
end
