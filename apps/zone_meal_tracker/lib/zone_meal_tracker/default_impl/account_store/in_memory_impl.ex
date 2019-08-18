defmodule ZoneMealTracker.DefaultImpl.AccountStore.InMemoryImpl do
  @moduledoc false
  use Agent

  import ZoneMealTracker.DefaultImpl.AccountStore.Guards

  alias ZoneMealTracker.DefaultImpl.AccountStore
  alias ZoneMealTracker.DefaultImpl.AccountStore.InMemoryImpl.State
  alias ZoneMealTracker.DefaultImpl.AccountStore.Login
  alias ZoneMealTracker.DefaultImpl.AccountStore.User

  @behaviour ZoneMealTracker.DefaultImpl.AccountStore.Impl

  @default_instance __MODULE__

  defguardp is_server(term) when is_atom(term) or is_pid(term) or is_tuple(term)

  def start_link(opts) do
    start_opts = Keyword.take(opts, [:name])

    Agent.start_link(&State.new/0, start_opts)
  end

  @impl true
  @spec create_user(User.username(), User.password()) ::
          {:ok, User.t()} | {:error, :username_not_unique}
  def create_user(instance \\ @default_instance, username, password)
      when is_server(instance) and is_username(username) and is_password(password) do
    Agent.get_and_update(instance, &State.create_user(&1, username, password))
  end

  @spec fetch_user_for_id(User.id()) :: {:ok, User.t()}
  def fetch_user_for_id(instance \\ @default_instance, user_id)
      when is_server(instance) and is_user_id(user_id) do
    Agent.get(instance, &State.fetch_user_for_id(&1, user_id))
  end

  @impl true
  @spec fetch_user_by_username_and_password(User.username(), User.password()) ::
          {:ok, User.t()} | {:error, :not_found}
  def fetch_user_by_username_and_password(instance \\ @default_instance, username, password)
      when is_server(instance) and is_username(username) and is_password(password) do
    Agent.get(instance, &State.fetch_user_by_username_and_password(&1, username, password))
  end

  @spec delete_user(User.id()) :: :ok
  def delete_user(instance \\ @default_instance, user_id)
      when is_server(instance) and is_user_id(user_id) do
    Agent.get_and_update(instance, &State.delete_user(&1, user_id))
  end

  @impl true
  @spec create_login(User.id()) :: {:ok, Login.t()}
  def create_login(instance \\ @default_instance, user_id)
      when is_server(instance) and is_user_id(user_id) do
    Agent.get_and_update(instance, &State.create_login(&1, user_id))
  end

  @impl true
  @spec fetch_user_for_login_id(Login.id()) :: {:ok, User.t()} | {:error, :not_found}
  def fetch_user_for_login_id(instance \\ @default_instance, login_id)
      when is_login_id(login_id) do
    Agent.get(instance, &State.fetch_user_for_login_id(&1, login_id))
  end

  @impl true
  @spec delete_login(Login.id()) :: :ok
  def delete_login(instance \\ @default_instance, login_id)
      when is_server(instance) and is_login_id(login_id) do
    Agent.get_and_update(instance, &State.delete_login(&1, login_id))
  end

  @impl true
  @spec reset([AccountStore.reset_opt()]) :: :ok
  def reset(instance \\ @default_instance, opts) when is_server(instance) and is_list(opts) do
    case Keyword.fetch(opts, :force) do
      {:ok, true} ->
        Agent.update(instance, &State.reset/1)

      _ ->
        raise ArgumentError, "{:force, true} is required to reset this system"
    end
  end
end
