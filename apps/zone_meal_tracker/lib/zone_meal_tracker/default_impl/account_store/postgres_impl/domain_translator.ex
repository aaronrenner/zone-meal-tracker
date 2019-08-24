defmodule ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl.DomainTranslator do
  @moduledoc false

  alias ZoneMealTracker.DefaultImpl.AccountStore
  alias ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl

  @spec to_domain_user(PostgresImpl.User.t()) :: AccountStore.User.t()
  def to_domain_user(%PostgresImpl.User{} = user) do
    user
    |> Map.from_struct()
    |> Map.take([:id, :email])
    |> (&struct!(AccountStore.User, &1)).()
  end

  @spec to_domain_login(PostgresImpl.Login.t()) :: AccountStore.Login.t()
  def to_domain_login(%PostgresImpl.Login{} = login) do
    login
    |> Map.from_struct()
    |> Map.take([:id, :user_id])
    |> (&struct!(AccountStore.Login, &1)).()
  end
end
