defmodule ZoneMealTracker.Guards do
  @moduledoc false

  # Guards useable for domain-level concepts

  defguard is_email(term) when is_binary(term)
  defguard is_password(term) when is_binary(term)
  defguard is_login_id(data) when is_binary(data)
  defguard is_user_id(data) when is_binary(data)
end
