defmodule ZoneMealTracker.DefaultImpl.AccountStore.Impl do
  @moduledoc false

  alias ZoneMealTracker.DefaultImpl.AccountStore
  alias ZoneMealTracker.DefaultImpl.AccountStore.Login
  alias ZoneMealTracker.DefaultImpl.AccountStore.User

  @callback create_user(User.email(), User.password()) ::
              {:ok, User.t()} | {:error, :email_not_unique}

  @callback create_login(User.id()) :: {:ok, Login.t()} | {:error, :unknown_user_id}

  @callback fetch_user_for_login_id(Login.id()) :: {:ok, User.t()} | {:error, :not_found}

  @callback fetch_user_by_email_and_password(User.email(), User.password()) ::
              {:ok, User.t()} | {:error, :not_found}

  @callback delete_login(Login.id()) :: :ok

  @callback reset([AccountStore.reset_opt()]) :: :ok
end
