defmodule ZMTConfig.DefaultImplTest do
  use ExUnit.Case, async: false

  alias ZMTConfig.Config
  alias ZMTConfig.DefaultImpl
  alias ZMTConfig.InvalidConfigurationError

  test "fetch_config/0 returns {:ok, %Config{}} with values from environment when settings are set" do
    ensure_settings_are_reset(:zmt_config, [:secret_key_base, :http_port, :url])

    secret_key_base = "foobar"
    port = 5400
    url_setting = [host: "foo.com"]

    Application.put_all_env(
      zmt_config: [
        http_port: port,
        url: url_setting,
        secret_key_base: secret_key_base
      ]
    )

    assert {:ok,
            %Config{
              secret_key_base: ^secret_key_base,
              http_port: ^port,
              url: ^url_setting,
              http_uri_base: http_uri_base
            }} = DefaultImpl.fetch_config()

    assert to_string(http_uri_base) == "http://foo.com:#{port}"
  end

  test "fetch_config/0 returns defaults for optional fields" do
    ensure_settings_are_reset(:zmt_config, [:secret_key_base, :http_port, :url])

    secret_key_base = "foobar"

    Application.put_env(:zmt_config, :secret_key_base, secret_key_base)
    Application.delete_env(:zmt_config, :http_port)
    Application.delete_env(:zmt_config, :url)

    assert {:ok,
            %Config{
              http_port: 4000,
              url: [],
              http_uri_base: http_uri_base,
              secret_key_base: ^secret_key_base
            }} = DefaultImpl.fetch_config()

    assert to_string(http_uri_base) == "http://localhost:4000"
  end

  test "fetch_config/0 returns {:error, InvalidConfigurationError} when secret_key_base is missing" do
    ensure_settings_are_reset(:zmt_config, [:secret_key_base])

    Application.delete_env(:zmt_config, :secret_key_base)

    assert {:error, %InvalidConfigurationError{key: :secret_key_base}} =
             DefaultImpl.fetch_config()
  end

  defp ensure_settings_are_reset(otp_app, keys) when is_list(keys) do
    Enum.each(keys, &ensure_setting_is_reset(otp_app, &1))
  end

  defp ensure_setting_is_reset(otp_app, key) do
    original = Application.fetch_env(otp_app, key)

    on_exit(fn ->
      case original do
        {:ok, value} ->
          Application.put_env(otp_app, key, value)

        :error ->
          Application.delete_env(otp_app, key)
      end
    end)
  end
end
