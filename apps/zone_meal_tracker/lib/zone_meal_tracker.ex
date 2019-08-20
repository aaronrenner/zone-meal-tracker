defmodule ZoneMealTracker do
  @moduledoc """
  Main API for ZoneMealTracker application
  """

  import ZoneMealTracker.Guards

  alias ZoneMealTracker.DefaultImpl
  alias ZoneMealTracker.Login
  alias ZoneMealTracker.User

  @behaviour ZoneMealTracker.Impl

  @type user_id :: User.id()
  @type login_id :: User.id()

  @doc """
  Registers a new user with email and password.
  """
  @impl true
  @spec register_user(String.t(), String.t()) ::
          {:ok, User.t()} | {:error, :email_already_registered}
  def register_user(email, password) when is_email(email) and is_password(password) do
    current_impl().register_user(email, password)
  end

  @doc """
  Fetches a user with the matching email and password
  """
  @impl true
  @spec fetch_user_by_email_and_password(String.t(), String.t()) ::
          {:ok, User.t()} | {:error, :not_found}
  def fetch_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    current_impl().fetch_user_by_email_and_password(email, password)
  end

  @doc """
  Fetches the user associated with a login id
  """
  @impl true
  @spec fetch_user_for_login_id(login_id) :: {:ok, User.t()} | {:error, :not_found}
  def fetch_user_for_login_id(login_id) when is_login_id(login_id) do
    current_impl().fetch_user_for_login_id(login_id)
  end

  @doc """
  Creates a login for the user id
  """
  @impl true
  @spec create_login(user_id) :: {:ok, Login.t()} | {:error, :unknown_user_id}
  def create_login(user_id) when is_user_id(user_id) do
    current_impl().create_login(user_id)
  end

  @doc """
  Deletes a login record
  """
  @impl true
  @spec delete_login(login_id) :: :ok
  def delete_login(login_id) when is_login_id(login_id) do
    current_impl().delete_login(login_id)
  end

  @type reset_system_opt :: {:force, true}

  @doc """
  Deletes all data in the system.

  Useful for testing. Requires `force: true`
  """
  @impl true
  @spec reset_system([reset_system_opt]) :: :ok
  def reset_system(opts \\ []) when is_list(opts) do
    current_impl().reset_system(opts)
  end

  @doc false
  def current_impl do
    Application.get_env(:zone_meal_tracker, :impl, DefaultImpl)
  end
end
