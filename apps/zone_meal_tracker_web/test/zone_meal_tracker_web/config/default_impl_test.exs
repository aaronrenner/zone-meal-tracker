defmodule ZoneMealTrackerWeb.Config.DefaultImplTest do
  use ExUnit.Case, async: true

  alias ZMTConfig.Config
  alias ZoneMealTrackerWeb.Config.DefaultImpl

  test "fetch_http_port/0 returns the same value from ZMTConfig" do
    %Config{http_port: http_port} = ZMTConfig.get_config()

    assert {:ok, ^http_port} = DefaultImpl.fetch_http_port()
  end

  test "fetch_url_settings/0 returns the same value from ZMTConfig" do
    %Config{url: url_settings} = ZMTConfig.get_config()

    assert {:ok, ^url_settings} = DefaultImpl.fetch_url_settings()
  end

  test "fetch_secret_key_base/0 returns the secret_key_base from the environment" do
    secret_key_base =
      :zone_meal_tracker_web
      |> Application.fetch_env!(ZoneMealTrackerWeb.Endpoint)
      |> Keyword.fetch!(:secret_key_base)

    assert {:ok, ^secret_key_base} = DefaultImpl.fetch_secret_key_base()
  end
end
