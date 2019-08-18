defmodule ZoneMealTrackerWeb.Authentication.DefaultImpl.SessionTest do
  use ZoneMealTrackerWeb.ConnCase, async: true

  alias ZoneMealTrackerWeb.Authentication.DefaultImpl.Session

  test "putting, retrieving and deleting the login id from the session", %{conn: conn} do
    login_id = "abc123"

    conn =
      conn
      |> within_request(&Session.put_login_id(&1, login_id))
      |> initialize_session()

    assert {:ok, ^login_id} = Session.fetch_login_id(conn)

    conn =
      conn
      |> within_request(&Session.delete_login_id/1)
      |> initialize_session()

    assert {:error, :not_found} = Session.fetch_login_id(conn)
  end

  test "fetch_login_id/1 returns {:error, :not_found} not found", %{conn: conn} do
    assert {:error, :not_found} =
             conn
             |> initialize_session()
             |> Session.fetch_login_id()
  end

  test "delete_login_id/1 works when login id hasn't been put", %{conn: conn} do
    conn =
      conn
      |> within_request(&Session.delete_login_id/1)
      |> initialize_session()

    assert {:error, :not_found} = Session.fetch_login_id(conn)
  end
end
