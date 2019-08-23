defmodule ZoneMealTrackerWeb.PasswordControllerTest do
  use ZoneMealTrackerWeb.ConnCase, async: true

  import Mox

  alias ZoneMealTrackerWeb.MockZoneMealTracker

  setup [:set_mox_from_context, :verify_on_exit!, :set_initial_auth_status]

  @moduletag :capture_log

  test "GET new/2 renders the forgot password form", %{conn: conn} do
    conn = get(conn, Routes.password_path(conn, :new))
    assert html_response(conn, 200) =~ ~r/forgot password/i
  end

  test "POST create/2 renders email sent flash message with valid params", %{conn: conn} do
    email = "foo@bar.com"
    params = %{"forgot_password_form" => %{"email" => email}}

    expect(MockZoneMealTracker, :send_forgot_password_link, fn ^email ->
      :ok
    end)

    conn = post(conn, Routes.password_path(conn, :create), params)

    assert redirected_to(conn) == Routes.password_path(conn, :new)
    assert get_flash(conn)["info"] =~ "receive an email"
  end

  test "POST create/2 rerenders form with invalid data", %{conn: conn} do
    conn = post(conn, Routes.password_path(conn, :create), %{})

    assert html_response(conn, 422) =~ ~r/forgot password/i
  end
end
