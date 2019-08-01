defmodule IntegrationTester.Pages.HomePage do
  @moduledoc false

  use Wallaby.DSL

  @sign_up_link Query.link("Sign Up")

  def path, do: "/"

  def click_sign_up_link(session) do
    click(session, @sign_up_link)
  end
end
