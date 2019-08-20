defmodule IntegrationTesterTest do
  use ExUnit.Case
  use Wallaby.DSL

  alias IntegrationTester.Pages.HomePage
  alias IntegrationTester.Pages.LoginPage

  @moduletag :capture_log

  @email "foo@bar.com"
  @password "password"

  setup do
    ZoneMealTracker.reset_system(force: true)

    {:ok, _} = ZoneMealTracker.register_user(@email, @password)
    :ok
  end

  test "home page requires authentication" do
    {:ok, session} = Wallaby.start_session()

    session
    |> visit(HomePage.path())
    |> assert_current_path(LoginPage.path())
    |> LoginPage.log_in(@email, @password)
    |> assert_has(Query.text("Welcome to Phoenix!"))
    |> assert_current_path(HomePage.path())
  end

  defp assert_current_path(session, path) when is_binary(path) do
    assert current_path(session) == path

    session
  end
end
