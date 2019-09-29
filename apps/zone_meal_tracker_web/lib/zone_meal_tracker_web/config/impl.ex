defmodule ZoneMealTrackerWeb.Config.Impl do
  @moduledoc false

  @type url_settings :: Keyword.t()
  @type port_number :: non_neg_integer()

  @callback fetch_http_port() :: {:ok, port_number}
  @callback fetch_url_settings() :: {:ok, url_settings}
end
