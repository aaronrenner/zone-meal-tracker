defmodule IntegrationTester.Pages.MealTrackerPage do
  @moduledoc false

  use Wallaby.DSL

  @path "/log"

  @previous_day_link Query.link("Prev")
  @next_day_link Query.link("Next")

  def visit(session) do
    visit(session, @path)
  end

  def visit_for_date(session, date) do
    visit(session, @path <> "/" <> Date.to_iso8601(date))
  end

  def click_next_day(session) do
    click(session, @next_day_link)
  end

  def click_previous_day(session) do
    click(session, @previous_day_link)
  end

  def assert_current_date(session, date) do
    query = Query.css(~s|[data-current-date="#{Date.to_iso8601(date)}"]|)
    assert_has(session, query)
  end
end
