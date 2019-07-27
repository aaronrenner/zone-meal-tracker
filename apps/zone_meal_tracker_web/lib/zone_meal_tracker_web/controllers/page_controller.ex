defmodule ZoneMealTrackerWeb.PageController do
  use ZoneMealTrackerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
