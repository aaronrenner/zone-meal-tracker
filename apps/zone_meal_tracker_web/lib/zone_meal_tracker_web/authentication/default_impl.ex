defmodule ZoneMealTrackerWeb.Authentication.DefaultImpl do
  @moduledoc false

  alias Plug.Conn
  alias ZoneMealTracker.Login
  alias ZoneMealTracker.User
  alias ZoneMealTrackerWeb.Authentication.DefaultImpl.Session

  @behaviour ZoneMealTrackerWeb.Authentication.Impl

  @impl true
  @spec fetch_current_user(Conn.t()) :: {:ok, User.t()} | {:error, :unauthenticated}
  def fetch_current_user(conn) do
    with {:ok, login_id} <- Session.fetch_login_id(conn),
         {:ok, user} <- ZoneMealTracker.fetch_user_for_login_id(login_id) do
      {:ok, user}
    else
      _ ->
        {:error, :unauthenticated}
    end
  end

  @impl true
  @spec log_in(Conn.t(), User.t()) :: Conn.t()
  def log_in(conn, %User{id: user_id}) do
    case ZoneMealTracker.create_login(user_id) do
      {:ok, %Login{id: login_id}} ->
        Session.put_login_id(conn, login_id)
    end
  end

  @impl true
  @spec log_out(Conn.t()) :: Conn.t()
  def log_out(conn) do
    case Session.fetch_login_id(conn) do
      {:ok, login_id} ->
        :ok = ZoneMealTracker.delete_login(login_id)

      {:error, :not_found} ->
        :ok
    end

    Session.delete_login_id(conn)
  end
end
