defmodule ZoneMealTrackerWeb.SessionControllerTest do
  use ZoneMealTrackerWeb.ConnCase, async: true

  import Mox

  alias ZoneMealTracker.User
  alias ZoneMealTrackerWeb.MockAuthentication
  alias ZoneMealTrackerWeb.MockZoneMealTracker

  setup [:set_mox_from_context, :verify_on_exit!, :set_initial_auth_status]

  @moduletag :capture_log

  test "GET new/2 renders the login form", %{conn: conn} do
    conn = get(conn, Routes.session_path(conn, :new))
    assert html_response(conn, 200) =~ "email"
  end

  test "POST create/2 redirects to index page on successful auth", %{conn: conn} do
    email = "foo@bar.com"
    password = "bar"
    mock_user = %User{id: "1", email: "foo@bar.com"}

    expect(MockZoneMealTracker, :fetch_user_by_email_and_password, fn ^email, ^password ->
      {:ok, %User{id: "1", email: "foo@bar.com"}}
    end)

    expect(MockAuthentication, :log_in, fn conn, ^mock_user -> conn end)

    conn =
      post conn, Routes.session_path(conn, :create), %{
        "login_form" => %{"email" => email, "password" => password}
      }

    assert redirected_to(conn) == Routes.page_path(conn, :index)
  end

  test "POST create/2 rerenders the login form on unsuccessful auth", %{conn: conn} do
    email = "foo@bar.com"
    password = "bar"

    expect(MockZoneMealTracker, :fetch_user_by_email_and_password, fn ^email, ^password ->
      {:error, :not_found}
    end)

    conn =
      post conn, Routes.session_path(conn, :create), %{
        "login_form" => %{"email" => email, "password" => password}
      }

    assert html_response(conn, 200) =~ "Invalid email/password"
  end
end
