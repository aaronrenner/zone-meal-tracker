defmodule ZoneMealTracker do
  @moduledoc """
  Main API for ZoneMealTracker application
  """

  alias ZoneMealTracker.DevImpl
  alias ZoneMealTracker.User

  @behaviour ZoneMealTracker.Impl

  @doc """
  Registers a new user with email and password.
  """
  @impl true
  @spec register_user(String.t(), String.t()) :: {:ok, User.t()}
  def register_user(email, password) when is_binary(email) and is_binary(password) do
    current_impl().register_user(email, password)
  end

  defp current_impl do
    Application.get_env(:zone_meal_tracker, :impl, DevImpl)
  end
end
