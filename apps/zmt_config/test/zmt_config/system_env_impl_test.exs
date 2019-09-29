defmodule ZMTConfig.SystemEnvImplTest do
  use ExUnit.Case, async: false

  alias ZMTConfig.Config
  alias ZMTConfig.InvalidConfigurationError
  alias ZMTConfig.SystemEnvImpl

  test "fetch_config/0 returns {:ok, %Config{}} with values from environment when settings are set" do
    ensure_env_vars_are_reset(~w(ZMT_SECRET_KEY_BASE ZMT_HTTP_PORT ZMT_URL_HOST))

    secret_key_base = "super-secret"
    port = 5201
    url_host = "zonemealtracker.com"

    System.put_env([
      {"ZMT_SECRET_KEY_BASE", secret_key_base},
      {"ZMT_HTTP_PORT", to_string(port)},
      {"ZMT_URL_HOST", url_host}
    ])

    assert {:ok,
            %Config{
              secret_key_base: ^secret_key_base,
              http_port: ^port,
              url: [host: ^url_host, port: ^port],
              http_uri_base: http_uri_base
            }} = SystemEnvImpl.fetch_config()

    assert to_string(http_uri_base) == "http://#{url_host}:#{port}"
  end

  test "fetch_config/0 returns defaults for optional fields" do
    ensure_env_vars_are_reset(~w(ZMT_SECRET_KEY_BASE ZMT_HTTP_PORT ZMT_URL_HOST))

    secret_key_base = "super-secret-bar"

    System.put_env([{"ZMT_SECRET_KEY_BASE", secret_key_base}])
    System.delete_env("ZMT_HTTP_PORT")
    System.delete_env("ZMT_URL_HOST")

    assert {:ok,
            %Config{
              http_port: 4000,
              url: [host: "localhost", port: 4000],
              http_uri_base: http_uri_base,
              secret_key_base: ^secret_key_base
            }} = SystemEnvImpl.fetch_config()

    assert to_string(http_uri_base) == "http://localhost:4000"
  end

  test "fetch_config/0 returns {:error, InvalidConfigurationError} when secret_key_base is missing" do
    ensure_env_vars_are_reset(~w(ZMT_SECRET_KEY_BASE))

    System.delete_env("ZMT_SECRET_KEY_BASE")

    assert {:error, %InvalidConfigurationError{key: "ZMT_SECRET_KEY_BASE"}} =
             SystemEnvImpl.fetch_config()
  end

  test "fetch_config/0 returns {:error, InvalidConfigurationError} when ZMT_HTTP_PORT is can't be parsed into an integer" do
    ensure_env_vars_are_reset(~w(ZMT_SECRET_KEY_BASE ZMT_HTTP_PORT))

    System.put_env([{"ZMT_SECRET_KEY_BASE", "foo"}])
    System.put_env("ZMT_HTTP_PORT", "q")

    assert {:error, %InvalidConfigurationError{key: "ZMT_HTTP_PORT"}} =
             SystemEnvImpl.fetch_config()
  end

  defp ensure_env_vars_are_reset(varnames) when is_list(varnames) do
    Enum.each(varnames, &ensure_env_var_is_reset/1)
  end

  defp ensure_env_var_is_reset(varname) do
    original = System.fetch_env(varname)

    on_exit(fn ->
      case original do
        {:ok, value} ->
          System.put_env(varname, value)

        :error ->
          System.delete_env(varname)
      end
    end)
  end
end
