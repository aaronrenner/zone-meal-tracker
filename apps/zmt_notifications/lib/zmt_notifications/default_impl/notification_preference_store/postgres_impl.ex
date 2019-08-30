defmodule ZMTNotifications.DefaultImpl.NotificationPreferenceStore.PostgresImpl do
  @moduledoc false

  import ZMTNotifications.DefaultImpl.NotificationPreferenceStore.Guards

  alias __MODULE__.PrimaryEmail
  alias __MODULE__.Repo
  alias Ecto.UUID
  alias ZMTNotifications.DefaultImpl.NotificationPreferenceStore
  alias ZMTNotifications.DefaultImpl.NotificationPreferenceStore.Impl

  @behaviour Impl

  @type email :: Impl.email()
  @type user_id :: Impl.user_id()

  @doc false
  defdelegate child_spec(opts), to: __MODULE__.Repo

  @impl true
  @spec put_primary_email(user_id, email) :: :ok | {:error, :invalid_user_id}
  def put_primary_email(user_id, email) when is_user_id(user_id) and is_email(email) do
    %PrimaryEmail{}
    |> PrimaryEmail.changeset(%{user_id: user_id, email: email})
    |> Repo.insert!(on_conflict: [set: [email: email]], conflict_target: :user_id)

    :ok
  end

  @impl true
  @spec fetch_primary_email(user_id) :: {:ok, email} | {:error, :not_found}
  def fetch_primary_email(user_id) when is_user_id(user_id) do
    with {:ok, user_id} <- UUID.cast(user_id),
         %PrimaryEmail{email: email} <- Repo.get(PrimaryEmail, user_id) do
      {:ok, email}
    else
      _ ->
        {:error, :not_found}
    end
  end

  @impl true
  @spec reset([NotificationPreferenceStore.reset_opt()]) :: :ok
  def reset(opts) when is_list(opts) do
    case Keyword.fetch(opts, :force) do
      {:ok, true} ->
        Repo.delete_all(PrimaryEmail)

        :ok

      _ ->
        raise ArgumentError, "{:force, true} is required to reset this system"
    end
  end
end
