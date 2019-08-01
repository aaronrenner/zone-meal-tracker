defmodule IntegrationTester.Pages.SignUpPage do
  @moduledoc false

  use Wallaby.DSL

  @email_field Query.text_field("Email")
  @password_field Query.text_field("Password")
  @sign_up_button Query.button("Register")

  def register(session, email, password) do
    session
    |> fill_in(@email_field, with: email)
    |> fill_in(@password_field, with: password)
    |> click(@sign_up_button)
  end
end
