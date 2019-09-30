defmodule ZoneMealTrackerWeb.Config.SystemEnvImplTest do
  use ExUnit.Case, async: false
  use ExUnitProperties

  alias ZoneMealTrackerWeb.Config.InvalidConfigurationError
  alias ZoneMealTrackerWeb.Config.SystemEnvImpl

  @env_var_http_port "ZMT_HTTP_PORT"
  @env_var_secret_key_base "ZMT_SECRET_KEY_BASE"

  @env_vars [
    @env_var_http_port,
    @env_var_secret_key_base
  ]

  @port_number_min 0
  @port_number_max 65_535

  setup :ensure_env_vars_are_reset

  property "fetch_http_port/0 returns port number when #{@env_var_http_port} is between #{
             @port_number_min
           } and #{@port_number_max}" do
    check all port_number <- integer(@port_number_min..@port_number_max) do
      System.put_env(@env_var_http_port, to_string(port_number))

      assert {:ok, ^port_number} = SystemEnvImpl.fetch_http_port()
    end
  end

  property "fetch_http_port/0 {:error, %InvalidConfigurationError{}} when #{@env_var_http_port} is outside #{
             @port_number_min
           } and #{@port_number_max}" do
    check all port_number <-
                one_of([
                  integer(-100_000_000..@port_number_min),
                  integer(@port_number_max..100_000_000)
                ]) do
      System.put_env(@env_var_http_port, to_string(port_number))

      assert {:error, %InvalidConfigurationError{setting: @env_var_http_port}} =
               SystemEnvImpl.fetch_http_port()
    end
  end

  property "fetch_http_port/0 returns {:error, %InvalidConfigurationError{}} when port isn't parsable into an integer" do
    check all invalid_port_number <- invalid_port_number() do
      System.put_env(@env_var_http_port, invalid_port_number)

      assert {:error, %InvalidConfigurationError{setting: @env_var_http_port}} =
               SystemEnvImpl.fetch_http_port()
    end
  end

  test "fetch_http_port/0 returns {:error, %InvalidConfigurationError{}} when port isn't set" do
    System.delete_env(@env_var_http_port)

    assert {:error, %InvalidConfigurationError{setting: @env_var_http_port}} =
             SystemEnvImpl.fetch_http_port()
  end

  test "fetch_url_settings/0 returns {:ok, []}" do
    assert {:ok, []} = SystemEnvImpl.fetch_url_settings()
  end

  property "fetch_secret_key_base/0 returns {:ok, value} when set" do
    check all secret_key_base <- string(:alphanumeric) do
      System.put_env(@env_var_secret_key_base, secret_key_base)

      assert {:ok, ^secret_key_base} = SystemEnvImpl.fetch_secret_key_base()
    end
  end

  test "fetch_secret_key_base/0 returns {:error, %InvalidConfigurationError{}} when var isn't set" do
    System.delete_env(@env_var_secret_key_base)

    assert {:error, %InvalidConfigurationError{setting: @env_var_secret_key_base}} =
             SystemEnvImpl.fetch_secret_key_base()
  end

  defp invalid_port_number do
    gen all prefix <- string(?a..?z, min_length: 1),
            suffix <- string(:alphanumeric) do
      prefix <> suffix
    end
  end

  defp ensure_env_vars_are_reset(_) do
    Enum.each(@env_vars, &ensure_env_var_is_reset/1)
  end

  defp ensure_env_var_is_reset(var_name) do
    original_value = System.fetch_env(var_name)

    on_exit(fn ->
      case original_value do
        {:ok, value} ->
          System.put_env(var_name, value)

        :error ->
          System.delete_env(var_name)
      end
    end)
  end
end
