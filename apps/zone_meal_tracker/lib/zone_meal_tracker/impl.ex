defmodule ZoneMealTracker.Impl do
  @moduledoc false

  alias ZoneMealTracker.User

  @callback register_user(String.t(), String.t()) :: {:ok, User.t()}
end
