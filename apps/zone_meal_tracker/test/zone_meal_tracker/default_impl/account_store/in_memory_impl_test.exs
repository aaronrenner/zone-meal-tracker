defmodule ZoneMealTracker.DefaultImpl.AccountStore.InMemoryImplTest do
  use ExUnit.Case, async: true

  alias ZoneMealTracker.DefaultImpl.AccountStore.InMemoryImpl
  alias ZoneMealTracker.DefaultImpl.AccountStore.Login
  alias ZoneMealTracker.DefaultImpl.AccountStore.User

  setup do
    pid = start_supervised!(InMemoryImpl)

    {:ok, pid: pid}
  end

  test "creating and retrieving a user", %{pid: pid} do
    username = "foo"
    password = "bar"

    assert {:ok, %User{id: user_id} = user} = InMemoryImpl.create_user(pid, username, password)

    assert {:ok, ^user} = InMemoryImpl.fetch_user_for_id(pid, user_id)
  end

  test "create_user/3 when a username is already taken", %{pid: pid} do
    username = "foo"
    password = "bar"
    {:ok, _} = InMemoryImpl.create_user(pid, username, password)

    assert {:error, :username_not_unique} = InMemoryImpl.create_user(pid, username, password)
  end

  test "fetch_user_for_id/2 returns {:error, :not_found}, when the user isn't found", %{pid: pid} do
    user_id = "does_not_exist"

    assert {:error, :not_found} = InMemoryImpl.fetch_user_for_id(pid, user_id)
  end

  test "fetch_user_by_username_and_password/3 only returns {:ok, %User{}} if both fields match",
       %{pid: pid} do
    {:ok, user} = InMemoryImpl.create_user(pid, "good_username", "good_password")

    Enum.each(
      [
        {"good_username", "good_password"},
        {"bad_username", "good_password"},
        {"good_username", "bad_password"},
        {"bad_username", "bad_password"}
      ],
      fn
        {"good_username" = username, "good_password" = password} ->
          assert {:ok, ^user} =
                   InMemoryImpl.fetch_user_by_username_and_password(pid, username, password)

        {username, password} ->
          assert {:error, :not_found} =
                   InMemoryImpl.fetch_user_by_username_and_password(pid, username, password)
      end
    )
  end

  test "fetch_user_by_username_and_password/3 doesn't continue working after the user has been deleted",
       %{pid: pid} do
    username = "foo"
    password = "bar"

    {:ok, %User{id: user_id} = user} = InMemoryImpl.create_user(pid, username, password)
    {:ok, ^user} = InMemoryImpl.fetch_user_by_username_and_password(pid, username, password)
    :ok = InMemoryImpl.delete_user(pid, user_id)

    assert {:error, :not_found} =
             InMemoryImpl.fetch_user_by_username_and_password(pid, username, password)
  end

  test "delete_user/2 deletes a user when the user_id is found", %{pid: pid} do
    {:ok, %User{id: user_id}} = InMemoryImpl.create_user(pid, "user_1", "pass")

    assert :ok = InMemoryImpl.delete_user(pid, user_id)

    assert {:error, :not_found} = InMemoryImpl.fetch_user_for_id(pid, user_id)
  end

  test "delete_user/2 returns :ok when the user_id is not found", %{pid: pid} do
    assert :ok = InMemoryImpl.delete_user(pid, "does_not_exist")
  end

  test "create_login/2 creates a new login each time when the user_id exists", %{pid: pid} do
    {:ok, %User{id: user_id}} = InMemoryImpl.create_user(pid, "foo", "bar")

    {:ok, login_1} = InMemoryImpl.create_login(pid, user_id)
    {:ok, login_2} = InMemoryImpl.create_login(pid, user_id)

    refute login_1.id == login_2.id
  end

  test "create_login/2 returns {:error, :unknown_user_id} when user id does not exist", %{
    pid: pid
  } do
    assert {:error, :unknown_user_id} = InMemoryImpl.create_login(pid, "does_not_exist")
  end

  test "fetch_user_for_login_id/2 returns {:ok, %User{}} when the login id and user exist", %{
    pid: pid
  } do
    {:ok, user} = InMemoryImpl.create_user(pid, "foo", "bar")

    {:ok, %Login{id: login_id}} = InMemoryImpl.create_login(pid, user.id)

    assert {:ok, ^user} = InMemoryImpl.fetch_user_for_login_id(pid, login_id)
  end

  test "fetch_user_for_login_id/2 returns {:error, :not_found} when the login id does not exist",
       %{
         pid: pid
       } do
    assert {:error, :not_found} = InMemoryImpl.fetch_user_for_login_id(pid, "does_not_exist")
  end

  test "fetch_user_for_login_id/2 returns {:error, :not_found} when the user has been deleted", %{
    pid: pid
  } do
    {:ok, user} = InMemoryImpl.create_user(pid, "foo", "bar")

    {:ok, %Login{id: login_id}} = InMemoryImpl.create_login(pid, user.id)

    :ok = InMemoryImpl.delete_user(pid, user.id)

    assert {:error, :not_found} = InMemoryImpl.fetch_user_for_login_id(pid, login_id)
  end

  test "delete_login/2 deletes the login when the login id is found", %{pid: pid} do
    {:ok, user} = InMemoryImpl.create_user(pid, "foo", "bar")
    {:ok, %Login{id: login_id}} = InMemoryImpl.create_login(pid, user.id)

    :ok = InMemoryImpl.delete_login(pid, login_id)

    assert {:error, :not_found} = InMemoryImpl.fetch_user_for_login_id(pid, login_id)
  end

  test "delete_login/2 returns :ok when the login id does not exist", %{pid: pid} do
    login_id = "does_not_exist"

    :ok = InMemoryImpl.delete_login(pid, login_id)

    assert {:error, :not_found} = InMemoryImpl.fetch_user_for_login_id(pid, login_id)
  end

  test "reset/2 with force: true, resets the data store", %{pid: pid} do
    {:ok, %User{id: user_id}} = InMemoryImpl.create_user(pid, "foo", "bar")
    :ok = InMemoryImpl.reset(pid, force: true)

    assert {:error, :not_found} = InMemoryImpl.fetch_user_for_id(pid, user_id)
  end

  test "reset/2 without force_true, raises an ArgumentError", %{pid: pid} do
    assert_raise ArgumentError, fn ->
      InMemoryImpl.reset(pid, [])
    end
  end
end
