defmodule ZoneMealTrackerWeb.PageControllerTest do
  use ZoneMealTrackerWeb.ConnCase, async: true

  setup [:set_initial_auth_status]

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
