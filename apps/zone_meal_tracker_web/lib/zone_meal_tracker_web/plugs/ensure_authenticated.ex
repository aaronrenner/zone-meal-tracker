defmodule ZoneMealTrackerWeb.Plugs.EnsureAuthenticated do
  @moduledoc false

  import Plug.Conn
  import Phoenix.Controller

  alias ZoneMealTracker.User
  alias ZoneMealTrackerWeb.Authentication
  alias ZoneMealTrackerWeb.Router.Helpers, as: Routes

  @behaviour Plug

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    case Authentication.fetch_current_user(conn) do
      {:ok, %User{id: user_id}} ->
        assign(conn, :current_user_id, user_id)

      {:error, :unauthenticated} ->
        conn
        |> redirect(to: Routes.session_path(conn, :new))
        |> halt()
    end
  end
end
