defmodule IntegrationTester.Pages.LoginPage do
  @moduledoc false

  use Wallaby.DSL

  @username_field Query.text_field("Username")
  @password_field Query.text_field("Password")
  @log_in_button Query.button("Log in")

  def path, do: "/session/new"

  def log_in(session, username, password) do
    session
    |> fill_in(@username_field, with: username)
    |> fill_in(@password_field, with: password)
    |> click(@log_in_button)
  end
end
