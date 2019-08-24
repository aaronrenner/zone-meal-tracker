defmodule ZoneMealTracker.DefaultImpl.AccountStore do
  @moduledoc false

  import ZoneMealTracker.DefaultImpl.AccountStore.Guards

  alias ZoneMealTracker.DefaultImpl.AccountStore.Login
  alias ZoneMealTracker.DefaultImpl.AccountStore.User

  @behaviour ZoneMealTracker.DefaultImpl.AccountStore.Impl

  @doc false
  defdelegate child_spec(opts), to: __MODULE__.Supervisor

  @impl true
  @spec create_user(User.email(), User.password()) ::
          {:ok, User.t()} | {:error, :email_not_unique}
  def create_user(email, password) when is_email(email) and is_password(password) do
    impl().create_user(email, password)
  end

  @impl true
  @spec create_login(User.id()) :: {:ok, Login.t()} | {:error, :unknown_user_id}
  def create_login(user_id) when is_user_id(user_id) do
    impl().create_login(user_id)
  end

  @impl true
  @spec fetch_user_for_login_id(Login.id()) :: {:ok, User.t()} | {:error, :not_found}
  def fetch_user_for_login_id(login_id) when is_login_id(login_id) do
    impl().fetch_user_for_login_id(login_id)
  end

  @impl true
  @spec fetch_user_by_email_and_password(User.email(), User.password()) ::
          {:ok, User.t()} | {:error, :not_found}
  def fetch_user_by_email_and_password(email, password)
      when is_email(email) and is_password(password) do
    impl().fetch_user_by_email_and_password(email, password)
  end

  @impl true
  @spec delete_login(Login.id()) :: :ok
  def delete_login(login_id) when is_login_id(login_id) do
    impl().delete_login(login_id)
  end

  @type reset_opt :: {:force, true}

  @impl true
  @spec reset([reset_opt]) :: :ok
  def reset(opts) when is_list(opts) do
    impl().reset(opts)
  end

  defp impl do
    Application.get_env(:zone_meal_tracker, :account_store, __MODULE__.PostgresImpl)
  end
end
