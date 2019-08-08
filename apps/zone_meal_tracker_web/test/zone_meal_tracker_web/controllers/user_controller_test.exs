defmodule ZoneMealTrackerWeb.UserControllerTest do
  use ZoneMealTrackerWeb.ConnCase, async: true

  import Mox

  alias ZoneMealTrackerWeb.MockZoneMealTracker
  alias ZoneMealTracker.User

  @moduletag :capture_log

  setup [:set_mox_from_context]

  test "GET new/2 renders a form", %{conn: conn} do
    conn = get(conn, Routes.user_path(conn, :new))
    assert html_response(conn, :ok) =~ "Sign Up"
  end

  test "POST create/2 with valid params registers a user", %{conn: conn} do
    username = "foo"
    password = "password"
    params = %{"username" => username, "password" => password}

    expect(MockZoneMealTracker, :register_user, fn ^username, ^password ->
      {:ok, %User{id: "123", username: username}}
    end)

    conn = post conn, Routes.user_path(conn, :create), sign_up_form: params

    assert redirected_to(conn) == Routes.page_path(conn, :index)
  end

  test "POST create/2 rerenders the form when invalid data", %{conn: conn} do
    invalid_params = %{}
    conn = post(conn, Routes.user_path(conn, :create), sign_up_form: invalid_params)
    assert html_response(conn, :ok) =~ "Sign Up"
  end
end
