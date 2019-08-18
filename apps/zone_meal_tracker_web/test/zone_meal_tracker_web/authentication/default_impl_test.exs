defmodule ZoneMealTrackerWeb.Authentication.DefaultImplTest do
  use ZoneMealTrackerWeb.ConnCase, async: true

  import Mox

  alias ZoneMealTracker.User
  alias ZoneMealTrackerWeb.Authentication.DefaultImpl
  alias ZoneMealTrackerWeb.Authentication.DefaultImpl.Session
  alias ZoneMealTrackerWeb.MockZoneMealTracker

  setup [
    :set_mox_from_context,
    :verify_on_exit!
  ]

  @moduletag :capture_log

  test "fetch_current_user/1 returns {:error, :unauthenticated} when not logged in", %{conn: conn} do
    assert {:error, :unauthenticated} =
             conn
             |> initialize_session()
             |> DefaultImpl.fetch_current_user()
  end

  test "fetch_current_user/1 returns {:ok, user} when logged in", %{conn: conn} do
    login_id = "login_123"
    user = %User{id: "user_1", username: "foo"}

    expect(MockZoneMealTracker, :fetch_user_for_login_id, fn ^login_id ->
      {:ok, user}
    end)

    assert {:ok, ^user} =
             conn
             |> within_request(&Session.put_login_id(&1, login_id))
             |> initialize_session()
             |> DefaultImpl.fetch_current_user()

    # assert {:ok, ^user} =
    #          conn
    #          |> initialize_session()
    #          |> Session.put_login_id(login_id)
    #          |> send_resp(200, "")
    #          |> recycle()
    #          |> initialize_session()
    #          |> DefaultImpl.fetch_current_user()
  end

  test "fetch_current_user/1 returns {:error, :unauthenticated} when unable to find user for login id",
       %{conn: conn} do
    login_id = "login_123"

    expect(MockZoneMealTracker, :fetch_user_for_login_id, fn ^login_id ->
      {:error, :not_found}
    end)

    assert {:error, :unauthenticated} =
             conn
             |> within_request(&Session.put_login_id(&1, login_id))
             |> initialize_session()
             |> DefaultImpl.fetch_current_user()
  end

  test "log_out/1 deletes the current login and removes it from the session when the user is logged in",
       %{
         conn: conn
       } do
    login_id = "login_123"

    expect(MockZoneMealTracker, :delete_login, fn ^login_id -> :ok end)

    assert {:error, :not_found} =
             conn
             |> within_request(&Session.put_login_id(&1, login_id))
             |> within_request(&DefaultImpl.log_out/1)
             |> initialize_session()
             |> Session.fetch_login_id()
  end

  test "log_out/1 does nothing when not logged in",
       %{
         conn: conn
       } do
    assert {:error, :not_found} =
             conn
             |> within_request(&DefaultImpl.log_out/1)
             |> initialize_session()
             |> Session.fetch_login_id()
  end
end
