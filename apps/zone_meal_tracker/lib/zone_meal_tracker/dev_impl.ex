defmodule ZoneMealTracker.DevImpl do
  @moduledoc false

  alias ZoneMealTracker.User

  @behaviour ZoneMealTracker.Impl

  @user_id "1"

  @impl true
  @spec register_user(String.t(), String.t()) :: {:ok, User.t()}
  def register_user(username, _password) do
    {:ok, %User{id: @user_id, username: username}}
  end
end
