defmodule ZoneMealTrackerWeb.PageControllerTest do
  use ZoneMealTrackerWeb.ConnCase, async: true

  import Mox

  alias ZoneMealTracker.User
  alias ZoneMealTrackerWeb.MockAuthentication

  @moduletag :capture_log

  setup [:set_initial_auth_status]

  describe "when unauthenticated" do
    test "GET / redirects to login path", %{conn: conn} do
      conn = get(conn, "/")
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end
  end

  describe "when authenticated" do
    setup do
      expect(MockAuthentication, :fetch_current_user, fn _ ->
        {:ok, %User{id: "1", username: "foo"}}
      end)

      :ok
    end

    test "GET / displays homepage", %{conn: conn} do
      conn = get(conn, "/")
      assert html_response(conn, 200) =~ "Welcome to Phoenix!"
    end
  end
end
