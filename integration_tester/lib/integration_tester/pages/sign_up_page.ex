defmodule IntegrationTester.Pages.SignUpPage do
  @moduledoc false

  use Wallaby.DSL

  @username_field Query.text_field("Username")
  @password_field Query.text_field("Password")
  @sign_up_button Query.button("Register")

  def register(session, username, password) do
    session
    |> fill_in(@username_field, with: username)
    |> fill_in(@password_field, with: password)
    |> click(@sign_up_button)
  end
end
