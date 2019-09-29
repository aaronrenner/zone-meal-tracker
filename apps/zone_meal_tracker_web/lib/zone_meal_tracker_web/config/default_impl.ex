defmodule ZoneMealTrackerWeb.Config.DefaultImpl do
  @moduledoc false

  alias ZMTConfig.Config
  alias ZoneMealTrackerWeb.Config.Impl

  @behaviour ZoneMealTrackerWeb.Config.Impl

  @type url_settings :: Impl.url_settings()
  @type port_number :: Impl.port_number()

  @impl true
  @spec fetch_http_port() :: {:ok, port_number}
  def fetch_http_port do
    %Config{http_port: http_port} = ZMTConfig.get_config()

    {:ok, http_port}
  end

  @impl true
  @spec fetch_url_settings() :: {:ok, url_settings}
  def fetch_url_settings do
    %Config{url: url_settings} = ZMTConfig.get_config()

    {:ok, url_settings}
  end
end
