defmodule ZoneMealTrackerWeb.LayoutView do
  use ZoneMealTrackerWeb, :view

  alias ZoneMealTrackerWeb.Authentication

  def logged_in?(conn) do
    case Authentication.fetch_current_user(conn) do
      {:ok, _} -> true
      {:error, :unauthenticated} -> false
    end
  end
end
