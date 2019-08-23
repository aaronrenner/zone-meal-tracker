defmodule ZoneMealTrackerWeb.PasswordController.ForgotPasswordFormTest do
  use ZoneMealTrackerWeb.FormCase, async: true

  import Mox

  alias Ecto.Changeset
  alias ZoneMealTrackerWeb.MockZoneMealTracker
  alias ZoneMealTrackerWeb.PasswordController.ForgotPasswordForm

  setup [:set_mox_from_context, :verify_on_exit!]

  test "run/1 with valid params returns :ok" do
    email = "foo@bar.com"
    params = %{"email" => email}

    expect(MockZoneMealTracker, :send_forgot_password_link, fn ^email ->
      :ok
    end)

    assert :ok = ForgotPasswordForm.run(params)
  end

  test "run/1 with invalid params returns {:error, changeset}" do
    invalid_params = %{}

    assert {:error, changeset} = ForgotPasswordForm.run(invalid_params)

    assert %Changeset{valid?: false, action: :insert} = changeset
  end

  test "changeset/1 with valid params" do
    params = %{"email" => "foo@bar.com"}

    assert %Changeset{valid?: true} = ForgotPasswordForm.changeset(params)
  end

  test "changeset/2 with invalid params" do
    params = %{}

    changeset = ForgotPasswordForm.changeset(params)

    assert %Changeset{valid?: false} = changeset
    assert "can't be blank" in errors_on(changeset).email
  end
end
