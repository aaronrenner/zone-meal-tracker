defmodule ZoneMealTracker.DefaultImpl.DomainTranslatorTest do
  use ExUnit.Case, async: true

  alias ZoneMealTracker.DefaultImpl.AccountStore
  alias ZoneMealTracker.DefaultImpl.DomainTranslator
  alias ZoneMealTracker.Login
  alias ZoneMealTracker.User

  test "to_domain_user/1 translates an AccountStore.User to a User" do
    id = "123"
    email = "foo@bar.com"
    account_store_user = %AccountStore.User{id: id, email: email}

    assert %User{} = user = DomainTranslator.to_domain_user(account_store_user)

    assert_same_data(account_store_user, user)
  end

  test "to_domain_login/1 copies all fields across to the domain login" do
    account_store_login = %AccountStore.Login{id: "123", user_id: "user_456"}

    assert %Login{} = login = DomainTranslator.to_domain_login(account_store_login)

    assert_same_data(account_store_login, login)
  end

  defp assert_same_data(non_domain, domain) do
    non_domain_data = Map.from_struct(non_domain)
    domain_data = Map.from_struct(domain)

    assert non_domain_data == domain_data
  end
end
