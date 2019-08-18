defmodule IntegrationTester.Pages.Site do
  @moduledoc false

  use Wallaby.DSL

  @sign_up_link Query.link("Sign up")
  @log_in_link Query.link("Log in")
  @log_out_link Query.link("Log out")

  def click_sign_up_link(session) do
    click(session, @sign_up_link)
  end

  def click_log_in_link(session) do
    click(session, @log_in_link)
  end

  def assert_logged_in(session) do
    assert_has(session, @log_out_link)
  end

  def click_log_out_link(session) do
    click(session, @log_out_link)
  end

  def assert_logged_out(session) do
    assert_has(session, @log_in_link)
  end
end
