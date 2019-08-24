defmodule ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl.DomainTranslatorTest do
  use ExUnit.Case, async: true

  alias ZoneMealTracker.DefaultImpl.AccountStore.Login
  alias ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl
  alias ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl.DomainTranslator
  alias ZoneMealTracker.DefaultImpl.AccountStore.User

  test "to_domain_user/1 translates a PostgresImpl.User to User" do
    id = "123"
    email = "foo@bar.com"
    postgres_impl_user = %PostgresImpl.User{id: id, email: email}

    assert %User{} = user = DomainTranslator.to_domain_user(postgres_impl_user)

    assert_same_data(postgres_impl_user, user)
  end

  test "to_domain_login/1 translates a PostgresImpl.Login to Login" do
    id = "123"
    user_id = "user_123"
    postgres_impl_login = %PostgresImpl.Login{id: id, user_id: user_id}

    assert %Login{} = login = DomainTranslator.to_domain_login(postgres_impl_login)

    assert_same_data(postgres_impl_login, login)
  end

  defp assert_same_data(non_domain, domain) do
    non_domain_data = Map.from_struct(non_domain)
    domain_data = Map.from_struct(domain)
    keys_to_compare = Map.keys(domain_data)

    assert Map.take(non_domain_data, keys_to_compare) == domain_data
  end
end
