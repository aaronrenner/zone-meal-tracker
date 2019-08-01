defmodule IntegrationTesterTest do
  use ExUnit.Case
  use Wallaby.DSL

  alias IntegrationTester.Pages.HomePage
  alias IntegrationTester.Pages.SignUpPage

  @moduletag :capture_log

  test "home page works" do
    {:ok, session} = Wallaby.start_session()

    session
    |> visit(HomePage.path())
    |> assert_has(Query.text("Welcome to Phoenix!"))
  end

  test "user signup" do
    {:ok, session} = Wallaby.start_session()

    session
    |> visit(HomePage.path())
    |> HomePage.click_sign_up_link()
    |> SignUpPage.register("a@a.com", "password")
    |> assert_has(Query.text("Welcome to Phoenix!"))
  end
end
