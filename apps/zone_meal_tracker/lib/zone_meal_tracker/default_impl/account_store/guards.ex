defmodule ZoneMealTracker.DefaultImpl.AccountStore.Guards do
  @moduledoc false

  defguard is_login_id(term) when is_binary(term)
  defguard is_user_id(term) when is_binary(term)
  defguard is_username(term) when is_binary(term)
  defguard is_password(term) when is_binary(term)
end
