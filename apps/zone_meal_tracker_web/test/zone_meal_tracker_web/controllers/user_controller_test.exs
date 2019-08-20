defmodule ZoneMealTrackerWeb.UserControllerTest do
  use ZoneMealTrackerWeb.ConnCase, async: true

  import Mox

  alias ZoneMealTracker.User
  alias ZoneMealTrackerWeb.MockAuthentication
  alias ZoneMealTrackerWeb.MockZoneMealTracker

  @moduletag :capture_log

  setup [
    :set_mox_from_context,
    :set_initial_auth_status
  ]

  test "GET new/2 renders a form", %{conn: conn} do
    conn = get(conn, Routes.user_path(conn, :new))
    assert html_response(conn, :ok) =~ "Sign Up"
  end

  test "POST create/2 with valid params registers a user", %{conn: conn} do
    email = "foo@bar.com"
    password = "password"
    params = %{"email" => email, "password" => password}
    mock_user = %User{id: "123", email: email}

    expect(MockZoneMealTracker, :register_user, fn ^email, ^password ->
      {:ok, mock_user}
    end)

    expect(MockAuthentication, :log_in, fn conn, ^mock_user -> conn end)

    conn = post conn, Routes.user_path(conn, :create), sign_up_form: params

    assert redirected_to(conn) == Routes.page_path(conn, :index)
  end

  test "POST create/2 when email has already been registered", %{conn: conn} do
    email = "foo@bar.com"
    password = "password"
    params = %{"email" => email, "password" => password}

    expect(MockZoneMealTracker, :register_user, fn ^email, ^password ->
      {:error, :email_already_registered}
    end)

    conn = post conn, Routes.user_path(conn, :create), sign_up_form: params

    assert html_response(conn, :ok) =~ "Sign Up"
  end

  test "POST create/2 rerenders the form when invalid data", %{conn: conn} do
    invalid_params = %{}
    conn = post(conn, Routes.user_path(conn, :create), sign_up_form: invalid_params)
    assert html_response(conn, :ok) =~ "Sign Up"
  end
end
