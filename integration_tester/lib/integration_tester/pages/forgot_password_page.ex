defmodule IntegrationTester.Pages.ForgotPasswordPage do
  @moduledoc false
  use Wallaby.DSL

  @email_field Query.text_field("Email")
  @reset_password_button Query.button("Send reset link")

  def request_reset(session, email) do
    session
    |> fill_in(@email_field, with: email)
    |> click(@reset_password_button)
  end
end
