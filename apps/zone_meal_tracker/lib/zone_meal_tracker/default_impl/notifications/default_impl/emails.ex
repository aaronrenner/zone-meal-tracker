defmodule ZoneMealTracker.DefaultImpl.Notifications.DefaultImpl.Emails do
  @moduledoc false

  import __MODULE__.Guards

  alias __MODULE__.Impl

  @behaviour Impl

  @type email :: String.t()

  @impl true
  @spec send_welcome_email(email) :: :ok
  def send_welcome_email(email) when is_email(email) do
    current_impl().send_welcome_email(email)
  end

  defp current_impl do
    Application.get_env(
      :zone_meal_tracker,
      :emails_impl,
      __MODULE__.BambooImpl
    )
  end
end
