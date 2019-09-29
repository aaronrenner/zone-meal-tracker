defmodule ZoneMealTrackerWeb.Config do
  @moduledoc false

  alias ZoneMealTrackerWeb.Config.DefaultImpl

  @behaviour ZoneMealTrackerWeb.Config.Impl

  @type port_number :: non_neg_integer()
  @type url_settings :: Keyword.t()

  @impl true
  @spec fetch_http_port() :: {:ok, port_number}
  def fetch_http_port do
    impl().fetch_http_port()
  end

  @impl true
  @spec fetch_url_settings() :: {:ok, url_settings}
  def fetch_url_settings do
    impl().fetch_url_settings()
  end

  @impl true
  @spec fetch_secret_key_base() :: {:ok, String.t()}
  def fetch_secret_key_base do
    impl().fetch_secret_key_base()
  end

  defp impl do
    Application.get_env(:zone_meal_tracker_web, :config_impl, DefaultImpl)
  end
end
