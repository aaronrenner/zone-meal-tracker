defmodule IntegrationTester.Pages.LoginPage do
  @moduledoc false

  use Wallaby.DSL

  @email_field Query.text_field("Email")
  @password_field Query.text_field("Password")
  @log_in_button Query.button("Log in")
  @forgot_password_link Query.link("Forgot password")

  def path, do: "/session/new"

  def log_in(session, email, password) do
    session
    |> fill_in(@email_field, with: email)
    |> fill_in(@password_field, with: password)
    |> click(@log_in_button)
  end

  def click_forgot_password_link(session) do
    click(session, @forgot_password_link)
  end
end
