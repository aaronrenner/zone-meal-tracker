defmodule ZoneMealTrackerWeb.LogLive do
  @moduledoc false
  use Phoenix.LiveView

  alias Phoenix.View
  alias ZoneMealTrackerWeb.LogLive.InvalidParamError
  alias ZoneMealTrackerWeb.LogView

  def render(assigns) do
    View.render(LogView, "show.html", assigns)
  end

  def handle_params(params, _uri, socket) do
    with {:ok, date_param} <- Map.fetch(params, "date"),
         {:ok, date} <- Date.from_iso8601(date_param) do
      socket = assign(socket, date: date)
      {:noreply, socket}
    else
      _ ->
        raise InvalidParamError, message: "unable to parse valid date param"
    end
  end

  def mount(_session, socket) do
    {:ok, socket}
  end
end
