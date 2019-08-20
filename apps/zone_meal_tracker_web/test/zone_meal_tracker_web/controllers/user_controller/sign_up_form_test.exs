defmodule ZoneMealTrackerWeb.UserController.SignUpFormTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  import Mox

  alias Ecto.Changeset
  alias ZoneMealTracker.User
  alias ZoneMealTrackerWeb.MockZoneMealTracker
  alias ZoneMealTrackerWeb.UserController.SignUpForm

  setup [:set_mox_from_context, :verify_on_exit!]

  test "run/1 calls register_user with the correct params" do
    check all email <- email(),
              password <- string(:alphanumeric, min_length: 8) do
      params = %{
        "email" => email,
        "password" => password
      }

      user = %User{email: email}

      MockZoneMealTracker
      |> expect(:register_user, fn ^email, ^password ->
        {:ok, user}
      end)

      assert {:ok, ^user} = SignUpForm.run(params)
    end
  end

  test "run/1 when register_user says the email's already been registered" do
    check all email <- email(),
              password <- string(:alphanumeric, min_length: 8) do
      params = %{
        "email" => email,
        "password" => password
      }

      MockZoneMealTracker
      |> expect(:register_user, fn ^email, ^password ->
        {:error, :email_already_registered}
      end)

      assert {:error, %Changeset{} = changeset} = SignUpForm.run(params)
      assert "is already taken" in errors_on(changeset).email
      assert %Changeset{action: :insert} = changeset
    end
  end

  test "run/1 with missing params" do
    params = %{}

    assert {:error, %Changeset{} = changeset} = SignUpForm.run(params)
    assert "can't be blank" in errors_on(changeset).email
    assert "can't be blank" in errors_on(changeset).password
  end

  test "run/1 with an invalid email" do
    {:error, changeset} = SignUpForm.run(%{email: "a"})
    assert "must be a valid email" in errors_on(changeset).email
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

  defp email do
    [
      username: string(:alphanumeric, min_length: 1),
      domain: string(:alphanumeric, min_length: 1)
    ]
    |> fixed_map()
    |> map(fn %{username: username, domain: domain} -> "#{username}@#{domain}" end)
  end
end
