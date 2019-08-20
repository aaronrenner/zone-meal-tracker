defmodule ZoneMealTrackerWeb.Plugs.EnsureAuthenticatedTest do
  use ZoneMealTrackerWeb.ConnCase, async: true

  import Mox

  alias ZoneMealTracker.User
  alias ZoneMealTrackerWeb.MockAuthentication
  alias ZoneMealTrackerWeb.Plugs.EnsureAuthenticated

  test "call/2 redirects when unauthenticated", %{conn: conn} do
    expect(MockAuthentication, :fetch_current_user, fn _conn ->
      {:error, :unauthenticated}
    end)

    conn =
      []
      |> EnsureAuthenticated.init()
      |> (&EnsureAuthenticated.call(conn, &1)).()

    assert redirected_to(conn) =~ Routes.session_path(conn, :new)
    assert conn.halted
  end

  test "call/2 assigns current_user_id when authenticated", %{conn: conn} do
    user_id = "234"

    expect(MockAuthentication, :fetch_current_user, fn _conn ->
      {:ok, %User{id: user_id, email: "foo@bar.com"}}
    end)

    conn =
      []
      |> EnsureAuthenticated.init()
      |> (&EnsureAuthenticated.call(conn, &1)).()

    assert ^user_id = conn.assigns.current_user_id
    refute conn.halted
  end
end
