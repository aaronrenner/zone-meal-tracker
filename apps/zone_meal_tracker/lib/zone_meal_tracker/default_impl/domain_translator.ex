defmodule ZoneMealTracker.DefaultImpl.DomainTranslator do
  @moduledoc false

  alias ZoneMealTracker.DefaultImpl.AccountStore
  alias ZoneMealTracker.Login
  alias ZoneMealTracker.User

  @spec to_domain_user(AccountStore.User.t()) :: User.t()
  def to_domain_user(%AccountStore.User{} = user) do
    user
    |> Map.from_struct()
    |> (&struct!(User, &1)).()
  end

  @spec to_domain_login(AccountStore.Login.t()) :: Login.t()
  def to_domain_login(%AccountStore.Login{} = login) do
    login
    |> Map.from_struct()
    |> (&struct!(Login, &1)).()
  end
end
