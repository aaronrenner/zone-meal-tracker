defmodule IntegrationTester.MealTrackerTest do
  use ExUnit.Case
  use Wallaby.DSL

  alias IntegrationTester.Pages.MealTrackerPage

  @moduletag :capture_log

  test "starts at current date and allows for navigation between days" do
    {:ok, session} = Wallaby.start_session()

    {:ok, local_date} = get_local_date(session)

    session
    |> MealTrackerPage.visit()
    |> MealTrackerPage.assert_current_date(local_date)
    |> MealTrackerPage.click_previous_day()
    |> MealTrackerPage.assert_current_date(Date.add(local_date, -1))
    |> MealTrackerPage.click_next_day()
    |> MealTrackerPage.assert_current_date(local_date)
    |> MealTrackerPage.click_next_day()
    |> MealTrackerPage.assert_current_date(Date.add(local_date, 1))
  end

  @spec get_local_date(Browser.session()) :: {:ok, Date.t()} | {:error, :timeout}
  defp get_local_date(session) do
    javascript = """
    var now = new Date();

    // Month in JS is 0-based
    monthStr = (now.getMonth() + 1).toString().padStart(2, "0");
    dayOfMonthStr = now.getDate().toString().padStart(2, "0");
    yearStr = now.getFullYear().toString();

    return `${yearStr}-${monthStr}-${dayOfMonthStr}`
    """

    current_process = self()

    execute_script(session, javascript, [], fn str ->
      send(current_process, {:result, str})
    end)

    receive do
      {:result, date_str} ->
        {:ok, Date.from_iso8601!(date_str)}
    after
      2000 ->
        {:error, :timeout}
    end
  end
end
