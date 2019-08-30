defmodule ZoneMealTracker.DefaultImpl do
  @moduledoc false

  import ZoneMealTracker.Guards

  alias ZoneMealTracker.DefaultImpl.AccountStore
  alias ZoneMealTracker.DefaultImpl.DomainTranslator
  alias ZoneMealTracker.Login
  alias ZoneMealTracker.User

  @behaviour ZoneMealTracker.Impl

  @doc false
  defdelegate child_spec(opts), to: __MODULE__.Supervisor

  @impl true
  @spec register_user(String.t(), String.t()) ::
          {:ok, User.t()} | {:error, :email_already_registered}
  def register_user(email, password) when is_email(email) and is_password(password) do
    case AccountStore.create_user(email, password) do
      {:ok, %AccountStore.User{} = user} ->
        domain_user = DomainTranslator.to_domain_user(user)
        %User{id: user_id, email: email} = domain_user

        :ok = ZMTNotifications.set_user_email(user_id, email)
        :ok = ZMTNotifications.send_welcome_message(user_id)

        {:ok, domain_user}

      {:error, :email_not_unique} ->
        {:error, :email_already_registered}
    end
  end

  @impl true
  @spec fetch_user_by_email_and_password(String.t(), String.t()) ::
          {:ok, User.t()} | {:error, :not_found}
  def fetch_user_by_email_and_password(email, password)
      when is_email(email) and is_password(password) do
    case AccountStore.fetch_user_by_email_and_password(email, password) do
      {:ok, %AccountStore.User{} = user} ->
        {:ok, DomainTranslator.to_domain_user(user)}

      {:error, :not_found} ->
        {:error, :not_found}
    end
  end

  @impl true
  @spec create_login(User.id()) :: {:ok, Login.t()} | {:error, :unknown_user_id}
  def create_login(user_id) when is_user_id(user_id) do
    case AccountStore.create_login(user_id) do
      {:ok, %AccountStore.Login{} = login} ->
        {:ok, DomainTranslator.to_domain_login(login)}

      {:error, :unknown_user_id} ->
        {:error, :unknown_user_id}
    end
  end

  @impl true
  @spec fetch_user_for_login_id(Login.id()) :: {:ok, User.t()} | {:error, :not_found}
  def fetch_user_for_login_id(login_id) when is_login_id(login_id) do
    case AccountStore.fetch_user_for_login_id(login_id) do
      {:ok, %AccountStore.User{} = user} ->
        {:ok, DomainTranslator.to_domain_user(user)}

      {:error, :not_found} ->
        {:error, :not_found}
    end
  end

  @impl true
  @spec delete_login(Login.id()) :: :ok
  def delete_login(login_id) when is_login_id(login_id) do
    :ok = AccountStore.delete_login(login_id)
  end

  @impl true
  @spec reset_system([ZoneMealTracker.reset_system_opt()]) :: :ok | none
  def reset_system(opts) when is_list(opts) do
    case Keyword.fetch(opts, :force) do
      {:ok, true} ->
        :ok = AccountStore.reset(force: true)
        :ok = ZMTNotifications.reset(force: true)
        :ok

      _ ->
        raise ArgumentError, """
        must be called with `force: true`, because this wipes data from the entire system
        """
    end
  end
end
