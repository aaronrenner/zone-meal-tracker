defmodule ZoneMealTracker.DefaultImpl.AccountStore.PostgresImplTest do
  use ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl.DataCase, async: true

  alias Ecto.UUID
  alias ZoneMealTracker.DefaultImpl.AccountStore.Login
  alias ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl
  alias ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl.InvalidDataError
  alias ZoneMealTracker.DefaultImpl.AccountStore.User

  @moduletag :capture_log

  test "creating and retrieving a user" do
    email = "foo@bar.com"
    password = "bar"

    assert {:ok, %User{id: user_id} = user} = PostgresImpl.create_user(email, password)

    assert {:ok, ^user} = PostgresImpl.fetch_user_for_id(user_id)
  end

  test "create_user/3 when a email is already taken" do
    email = "foo@bar.com"
    password = "bar"
    {:ok, _} = PostgresImpl.create_user(email, password)

    assert {:error, :email_not_unique} = PostgresImpl.create_user(email, password)
  end

  test "create_user/3 raises with a blank email" do
    email = ""
    password = "bar"

    assert_raise InvalidDataError, fn ->
      PostgresImpl.create_user(email, password)
    end
  end

  test "fetch_user_for_id/2 returns {:error, :not_found}, when the user isn't found" do
    user_id = "does_not_exist"

    assert {:error, :not_found} = PostgresImpl.fetch_user_for_id(user_id)
  end

  test "fetch_user_for_id/2 returns {:error, :not_found}, with an invalid binary id" do
    user_id = UUID.generate()

    assert {:error, :not_found} = PostgresImpl.fetch_user_for_id(user_id)
  end

  test "fetch_user_by_email_and_password/3 only returns {:ok, %User{}} if both fields match" do
    {:ok, user} = PostgresImpl.create_user("good_email", "good_password")

    Enum.each(
      [
        {"good_email", "good_password"},
        {"bad_email", "good_password"},
        {"good_email", "bad_password"},
        {"bad_email", "bad_password"}
      ],
      fn
        {"good_email" = email, "good_password" = password} ->
          assert {:ok, ^user} = PostgresImpl.fetch_user_by_email_and_password(email, password)

        {email, password} ->
          assert {:error, :not_found} =
                   PostgresImpl.fetch_user_by_email_and_password(email, password)
      end
    )
  end

  test "fetch_user_by_email_and_password/3 doesn't continue working after the user has been deleted" do
    email = "foo@bar.com"
    password = "bar"

    {:ok, %User{id: user_id} = user} = PostgresImpl.create_user(email, password)
    {:ok, ^user} = PostgresImpl.fetch_user_by_email_and_password(email, password)
    :ok = PostgresImpl.delete_user(user_id)

    assert {:error, :not_found} = PostgresImpl.fetch_user_by_email_and_password(email, password)
  end

  test "delete_user/2 deletes a user when the user_id is found" do
    {:ok, %User{id: user_id}} = PostgresImpl.create_user("user_1", "pass")

    assert :ok = PostgresImpl.delete_user(user_id)

    assert {:error, :not_found} = PostgresImpl.fetch_user_for_id(user_id)
  end

  test "delete_user/2 returns :ok when the user_id is not found" do
    assert :ok = PostgresImpl.delete_user(UUID.generate())
  end

  test "delete_user/2 returns :ok when the user_id is invalid" do
    assert :ok = PostgresImpl.delete_user("does_not_exist")
  end

  test "create_login/2 creates a new login each time when the user_id exists" do
    {:ok, %User{id: user_id}} = PostgresImpl.create_user("foo@bar.com", "bar")

    {:ok, login_1} = PostgresImpl.create_login(user_id)
    {:ok, login_2} = PostgresImpl.create_login(user_id)

    refute login_1.id == login_2.id
  end

  test "create_login/2 returns {:error, :unknown_user_id} when user id is invalid" do
    assert {:error, :unknown_user_id} = PostgresImpl.create_login("does_not_exist")
  end

  test "create_login/2 returns {:error, :unknown_user_id} when user id does not exist" do
    assert {:error, :unknown_user_id} = PostgresImpl.create_login(UUID.generate())
  end

  test "fetch_user_for_login_id/2 returns {:ok, %User{}} when the login id and user exist" do
    {:ok, user} = PostgresImpl.create_user("foo@bar.com", "bar")

    {:ok, %Login{id: login_id}} = PostgresImpl.create_login(user.id)

    assert {:ok, ^user} = PostgresImpl.fetch_user_for_login_id(login_id)
  end

  test "fetch_user_for_login_id/2 returns {:error, :not_found} when the login id does not exist" do
    assert {:error, :not_found} = PostgresImpl.fetch_user_for_login_id(UUID.generate())
  end

  test "fetch_user_for_login_id/2 returns {:error, :not_found} when the login id is invalid" do
    assert {:error, :not_found} = PostgresImpl.fetch_user_for_login_id("does_not_exist")
  end

  test "fetch_user_for_login_id/2 returns {:error, :not_found} when the user has been deleted" do
    {:ok, user} = PostgresImpl.create_user("foo@bar.com", "bar")

    {:ok, %Login{id: login_id}} = PostgresImpl.create_login(user.id)

    :ok = PostgresImpl.delete_user(user.id)

    assert {:error, :not_found} = PostgresImpl.fetch_user_for_login_id(login_id)
  end

  test "delete_login/2 deletes the login when the login id is found" do
    {:ok, user} = PostgresImpl.create_user("foo@bar.com", "bar")
    {:ok, %Login{id: login_id}} = PostgresImpl.create_login(user.id)

    :ok = PostgresImpl.delete_login(login_id)

    assert {:error, :not_found} = PostgresImpl.fetch_user_for_login_id(login_id)
  end

  test "delete_login/2 returns :ok when the login id does not exist" do
    login_id = UUID.generate()

    :ok = PostgresImpl.delete_login(login_id)

    assert {:error, :not_found} = PostgresImpl.fetch_user_for_login_id(login_id)
  end

  test "delete_login/2 returns :ok when the login id is invalid" do
    login_id = "does_not_exist"

    :ok = PostgresImpl.delete_login(login_id)

    assert {:error, :not_found} = PostgresImpl.fetch_user_for_login_id(login_id)
  end

  test "reset/2 with force: true, resets the data store" do
    {:ok, %User{id: user_id}} = PostgresImpl.create_user("foo@bar.com", "bar")
    :ok = PostgresImpl.reset(force: true)

    assert {:error, :not_found} = PostgresImpl.fetch_user_for_id(user_id)
  end

  test "reset/2 without force_true, raises an ArgumentError" do
    assert_raise ArgumentError, fn ->
      PostgresImpl.reset([])
    end
  end
end
