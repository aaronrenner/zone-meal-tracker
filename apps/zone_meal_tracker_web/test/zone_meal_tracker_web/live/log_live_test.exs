defmodule ZoneMealTrackerWeb.LogLiveTest do
  use ZoneMealTrackerWeb.ConnCase, async: true

  alias ZoneMealTrackerWeb.LogLive

  @moduletag :capture_log

  setup [:set_initial_auth_status]

  test "GET with valid date works", %{conn: conn} do
    date = Date.utc_today()
    conn = get(conn, Routes.live_path(conn, LogLive, to_param(date)))

    assert html_response(conn, :ok)
  end

  test "GET with invalid date in url", %{conn: conn} do
    assert_error_sent :not_found, fn ->
      get(conn, Routes.live_path(conn, LogLive, "invalid-date"))
    end
  end

  defp to_param(%Date{} = date) do
    Date.to_iso8601(date)
  end
end
