defmodule ZoneMealTrackerWeb.Authentication do
  @moduledoc false

  alias Plug.Conn
  alias ZoneMealTracker.User
  alias ZoneMealTrackerWeb.Authentication.DefaultImpl

  @behaviour ZoneMealTrackerWeb.Authentication.Impl

  @impl true
  @spec fetch_current_user(Conn.t()) :: {:ok, User.t()} | {:error, :unauthenticated}
  def fetch_current_user(%Conn{} = conn) do
    current_impl().fetch_current_user(conn)
  end

  @impl true
  @spec log_in(Conn.t(), User.t()) :: Conn.t()
  def log_in(%Conn{} = conn, %User{} = user) do
    current_impl().log_in(conn, user)
  end

  @impl true
  @spec log_out(Conn.t()) :: Conn.t()
  def log_out(%Conn{} = conn) do
    current_impl().log_out(conn)
  end

  defp current_impl do
    Application.get_env(:zone_meal_tracker_web, :authentication_impl, DefaultImpl)
  end
end
