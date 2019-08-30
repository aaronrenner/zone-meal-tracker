defmodule ZMTNotifications.DefaultImpl do
  @moduledoc false

  import ZMTNotifications.Guards

  alias ZMTNotifications.DefaultImpl.Emails
  alias ZMTNotifications.DefaultImpl.NotificationPreferenceStore
  alias ZMTNotifications.Impl

  @behaviour ZMTNotifications.Impl

  @type email :: Impl.email()
  @type user_id :: Impl.user_id()

  @doc false
  defdelegate child_spec(opts), to: NotificationPreferenceStore

  @impl true
  @spec set_user_email(user_id, email) :: :ok | {:error, :invalid_user_id}
  def set_user_email(user_id, email) when is_user_id(user_id) and is_email(email) do
    case NotificationPreferenceStore.put_primary_email(user_id, email) do
      :ok ->
        :ok

      {:error, :invalid_user_id} ->
        {:error, :invalid_user_id}
    end
  end

  @impl true
  @spec send_welcome_message(user_id) :: :ok | {:error, :unknown_user_id}
  def send_welcome_message(user_id) when is_user_id(user_id) do
    case NotificationPreferenceStore.fetch_primary_email(user_id) do
      {:ok, email} ->
        Emails.send_welcome_email(email)
        :ok

      {:error, :not_found} ->
        {:error, :unknown_user_id}
    end
  end

  @impl true
  @spec reset([ZMTNotifications.reset_opt()]) :: :ok
  def reset(opts) when is_list(opts) do
    case Keyword.fetch(opts, :force) do
      {:ok, true} ->
        NotificationPreferenceStore.reset(force: true)

        :ok

      _ ->
        raise ArgumentError, "{:force, true} is required to reset this system"
    end
  end
end
