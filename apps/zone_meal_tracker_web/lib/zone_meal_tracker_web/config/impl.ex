defmodule ZoneMealTrackerWeb.Config.Impl do
  @moduledoc false

  alias ZoneMealTrackerWeb.Config.InvalidConfigurationError

  @type url_settings :: Keyword.t()
  @type port_number :: non_neg_integer()

  @callback fetch_http_port() :: {:ok, port_number} | {:error, InvalidConfigurationError.t()}
  @callback fetch_secret_key_base() :: {:ok, String.t()} | {:error, InvalidConfigurationError.t()}
  @callback fetch_url_settings() :: {:ok, url_settings} | {:error, InvalidConfigurationError.t()}
end
