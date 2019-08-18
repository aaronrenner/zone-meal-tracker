defmodule ZoneMealTracker.DefaultImplTest do
  use ExUnit.Case, async: true

  import Mox

  alias ZoneMealTracker.DefaultImpl
  alias ZoneMealTracker.DefaultImpl.AccountStore
  alias ZoneMealTracker.DefaultImpl.DomainTranslator
  alias ZoneMealTracker.DefaultImpl.MockAccountStore
  alias ZoneMealTracker.Login
  alias ZoneMealTracker.User

  setup [:set_mox_from_context, :verify_on_exit!]

  test "register_user/2 when username is unique" do
    username = "foo"
    password = "password"
    account_store_user = %AccountStore.User{id: "123", username: username}

    expect(MockAccountStore, :create_user, fn ^username, ^password ->
      {:ok, account_store_user}
    end)

    assert {:ok, %User{} = user} = DefaultImpl.register_user(username, password)

    assert user == DomainTranslator.to_domain_user(account_store_user)
  end

  test "register_user/2 when username is already taken" do
    username = "foo"
    password = "password"

    expect(MockAccountStore, :create_user, fn ^username, ^password ->
      {:error, :username_not_unique}
    end)

    assert {:error, :username_already_registered} = DefaultImpl.register_user(username, password)
  end

  test "fetch_user_by_username_and_password/2 when user is found" do
    username = "foo"
    password = "password"
    account_store_user = %AccountStore.User{id: "123", username: username}

    expect(MockAccountStore, :fetch_user_by_username_and_password, fn ^username, ^password ->
      {:ok, account_store_user}
    end)

    assert {:ok, %User{} = user} =
             DefaultImpl.fetch_user_by_username_and_password(username, password)

    assert user == DomainTranslator.to_domain_user(account_store_user)
  end

  test "fetch_user_by_username_and_password/2 when user is not found" do
    username = "foo"
    password = "password"

    expect(MockAccountStore, :fetch_user_by_username_and_password, fn ^username, ^password ->
      {:error, :not_found}
    end)

    assert {:error, :not_found} =
             DefaultImpl.fetch_user_by_username_and_password(username, password)
  end

  test "create_login/1 when the user id exists" do
    user_id = "user_123"
    account_store_login = %AccountStore.Login{id: "123", user_id: user_id}

    expect(MockAccountStore, :create_login, fn ^user_id ->
      {:ok, account_store_login}
    end)

    assert {:ok, %Login{} = login} = DefaultImpl.create_login(user_id)

    assert login == DomainTranslator.to_domain_login(account_store_login)
  end

  test "create_login/1 when user id does not exist" do
    user_id = "does_not_exist"

    expect(MockAccountStore, :create_login, fn ^user_id ->
      {:error, :unknown_user_id}
    end)

    assert {:error, :unknown_user_id} = DefaultImpl.create_login(user_id)
  end

  test "fetch_user_for_login_id/1 when found" do
    login_id = "login_123"
    account_store_user = %AccountStore.User{id: "123", username: "foo"}

    expect(MockAccountStore, :fetch_user_for_login_id, fn ^login_id ->
      {:ok, account_store_user}
    end)

    assert {:ok, %User{} = user} = DefaultImpl.fetch_user_for_login_id(login_id)

    assert user == DomainTranslator.to_domain_user(account_store_user)
  end

  test "fetch_user_for_login_id/1 when not found" do
    login_id = "login_123"

    expect(MockAccountStore, :fetch_user_for_login_id, fn ^login_id ->
      {:error, :not_found}
    end)

    assert {:error, :not_found} = DefaultImpl.fetch_user_for_login_id(login_id)
  end

  test "delete_login/1 returns :ok calls AccountStore.delete_login" do
    login_id = "login_123"

    expect(MockAccountStore, :delete_login, fn ^login_id -> :ok end)

    assert :ok = DefaultImpl.delete_login(login_id)
  end

  test "reset_system/1 with force: true, calls the various components resets" do
    expect(MockAccountStore, :reset, fn [force: true] -> :ok end)
    assert :ok = DefaultImpl.reset_system(force: true)
  end

  test "reset_system/1 without force: true, raises an exception" do
    assert_raise ArgumentError, fn ->
      DefaultImpl.reset_system([])
    end
  end
end
