defmodule IntegrationTesterTest do
  use ExUnit.Case
  use Wallaby.DSL

  alias IntegrationTester.Pages.HomePage

  @moduletag :capture_log

  test "home page works" do
    {:ok, session} = Wallaby.start_session()

    session
    |> visit(HomePage.path())
    |> assert_has(Query.text("Welcome to Phoenix!"))
  end
end
