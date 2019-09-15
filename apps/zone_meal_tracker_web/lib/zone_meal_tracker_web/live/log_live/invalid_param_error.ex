defmodule ZoneMealTrackerWeb.LogLive.InvalidParamError do
  @moduledoc false
  defexception [:message]

  defimpl Plug.Exception do
    def status(_), do: 404
  end
end
