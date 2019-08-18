defmodule ZoneMealTrackerWeb.Authentication.Impl do
  @moduledoc false

  alias Plug.Conn
  alias ZoneMealTracker.User

  @callback fetch_current_user(Conn.t()) :: {:ok, User.t()} | {:error, :unauthenticated}

  @callback log_in(Conn.t(), User.t()) :: Conn.t()

  @callback log_out(Conn.t()) :: Conn.t()
end
