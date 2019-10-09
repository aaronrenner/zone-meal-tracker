defmodule IntegrationTester.AuthenticationTest do
  use ExUnit.Case
  use Wallaby.DSL
  use Bamboo.Test, shared: true

  alias IntegrationTester.Emails
  alias IntegrationTester.Pages.HomePage
  alias IntegrationTester.Pages.LoginPage
  alias IntegrationTester.Pages.SignUpPage
  alias IntegrationTester.Pages.Site

  @moduletag :capture_log

  setup do
    ZoneMealTracker.reset_system(force: true)
  end

  test "user signup, logout, and login" do
    {:ok, session} = Wallaby.start_session()

    session =
      session
      |> visit(HomePage.path())
      |> Site.click_sign_up_link()
      |> SignUpPage.register("foo@bar.com", "password")
      |> Site.assert_logged_in()

    Emails.assert_email_delivered_with(
      to: ["foo@bar.com"],
      subject: "Welcome to ZoneMealTracker"
    )

    session
    |> Site.click_log_out_link()
    |> Site.assert_logged_out()
    |> Site.click_log_in_link()
    |> LoginPage.log_in("foo@bar.com", "incorrect")
    |> LoginPage.log_in("foo@bar.com", "password")
    |> Site.assert_logged_in()
    |> Site.click_log_out_link()
    |> Site.assert_logged_out()
  end

  @zmt_cookie_name "_zone_meal_tracker_web_key"

  test "cookies can't be reused after logging out" do
    {:ok, session_1} = Wallaby.start_session()

    session_1 =
      session_1
      |> visit(HomePage.path())
      |> Site.click_sign_up_link()
      |> SignUpPage.register("foo@bar.com", "password")
      |> Site.assert_logged_in()

    zmt_cookie_value = fetch_zmt_cookie_value!(session_1)

    {:ok, session_2} = Wallaby.start_session()

    session_2
    |> visit(HomePage.path())
    |> Browser.set_cookie(@zmt_cookie_name, zmt_cookie_value)
    |> visit(HomePage.path())
    |> Site.assert_logged_in()

    Site.click_log_out_link(session_1)

    session_1
    |> visit(HomePage.path())
    |> Site.assert_logged_out()

    session_2
    |> visit(HomePage.path())
    |> Site.assert_logged_out()
  end

  defp fetch_zmt_cookie_value!(session) do
    session
    |> Browser.cookies()
    |> Enum.find_value(fn
      %{"name" => @zmt_cookie_name, "value" => value} -> value
      _ -> false
    end)
    |> case do
      value when is_binary(value) ->
        value

      _ ->
        raise "unable to find cookie #{@zmt_cookie_name}"
    end
  end
end
