defmodule ZoneMealTrackerWeb.UserController.SignUpFormTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  import Mox

  alias ZoneMealTracker.User
  alias ZoneMealTrackerWeb.MockZoneMealTracker
  alias ZoneMealTrackerWeb.UserController.SignUpForm
  alias Ecto.Changeset

  setup [:set_mox_from_context, :verify_on_exit!]

  test "run/1 calls register_user with the correct params" do
    check all username <- string(:alphanumeric, min_length: 1),
              password <- string(:alphanumeric, min_length: 8) do
      params = %{
        "username" => username,
        "password" => password
      }

      user = %User{username: username}

      MockZoneMealTracker
      |> expect(:register_user, fn ^username, ^password ->
        {:ok, user}
      end)

      assert {:ok, ^user} = SignUpForm.run(params)
    end
  end

  test "run/1 with missing params" do
    params = %{}

    assert {:error, %Changeset{} = changeset} = SignUpForm.run(params)
    assert "can't be blank" in errors_on(changeset).username
    assert "can't be blank" in errors_on(changeset).password
  end

  test "run/1 with too short of a password" do
    {:error, changeset} = SignUpForm.run(%{password: "a"})
    assert "should be at least 8 character(s)" in errors_on(changeset).password
  end

  @doc """
  A helper that transform changeset errors to a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Changeset.traverse_errors(changeset, fn {message, opts} ->
      Enum.reduce(opts, message, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
