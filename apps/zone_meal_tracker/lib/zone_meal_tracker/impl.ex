defmodule ZoneMealTracker.Impl do
  @moduledoc false

  alias ZoneMealTracker.Login
  alias ZoneMealTracker.User

  @type user_id :: User.id()
  @type login_id :: Login.id()

  @callback register_user(String.t(), String.t()) ::
              {:ok, User.t()} | {:error, :email_already_registered}

  @callback fetch_user_by_email_and_password(String.t(), String.t()) ::
              {:ok, User.t()} | {:error, :not_found}

  @callback fetch_user_for_login_id(login_id) :: {:ok, User.t()} | {:error, :not_found}

  @callback create_login(user_id) :: {:ok, Login.t()} | {:error, :unknown_user_id}

  @callback delete_login(login_id) :: :ok

  @callback reset_system(force: true) :: :ok
end
