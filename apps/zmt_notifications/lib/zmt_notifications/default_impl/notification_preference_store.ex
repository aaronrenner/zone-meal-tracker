defmodule ZMTNotifications.DefaultImpl.NotificationPreferenceStore do
  @moduledoc false

  import __MODULE__.Guards

  alias __MODULE__.Impl

  @behaviour Impl

  @type user_id :: String.t()
  @type email :: String.t()

  @doc false
  defdelegate child_spec(opts), to: __MODULE__.PostgresImpl

  @impl true
  @spec put_primary_email(user_id, email) :: :ok | {:error, :invalid_user_id}
  def put_primary_email(user_id, email) when is_user_id(user_id) and is_email(email) do
    current_impl().put_primary_email(user_id, email)
  end

  @impl true
  @spec fetch_primary_email(user_id) :: {:ok, email} | {:error, :not_found}
  def fetch_primary_email(user_id) when is_user_id(user_id) do
    current_impl().fetch_primary_email(user_id)
  end

  @type reset_opt :: {:force, true}

  @impl true
  @spec reset([reset_opt]) :: :ok
  def reset(opts) when is_list(opts) do
    current_impl().reset(opts)
  end

  defp current_impl do
    Application.get_env(
      :zmt_notifications,
      :notification_preference_store_impl,
      __MODULE__.PostgresImpl
    )
  end
end
