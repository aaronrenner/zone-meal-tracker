defmodule ZMTConfig.SystemEnvImpl do
  @moduledoc false

  alias ZMTConfig.Config
  alias ZMTConfig.InvalidConfigurationError

  @behaviour ZMTConfig.Impl

  @default_http_port 4000
  @default_url_host "localhost"

  @secret_key_base_env_var "ZMT_SECRET_KEY_BASE"
  @http_port_env_var "ZMT_HTTP_PORT"
  @url_host_env_var "ZMT_URL_HOST"

  @typep port_number :: non_neg_integer()

  @impl true
  @spec fetch_config() :: {:ok, Config.t()} | {:error, InvalidConfigurationError.t()}
  def fetch_config do
    env = System.get_env()

    with {:ok, secret_key_base} <- get_required_value(env, @secret_key_base_env_var),
         {:ok, port_number} <- fetch_http_port(env, @http_port_env_var, @default_http_port) do
      url_host = Map.get(env, @url_host_env_var, @default_url_host)

      url_setting = [host: url_host, port: port_number]

      uri = struct!(%URI{scheme: "http"}, url_setting)

      config = %Config{
        url: url_setting,
        http_port: port_number,
        secret_key_base: secret_key_base,
        http_uri_base: uri
      }

      {:ok, config}
    end
  end

  @spec get_required_value(map, String.t()) ::
          {:ok, String.t()} | {:error, InvalidConfigurationError.t()}
  defp get_required_value(env, var_name) do
    case Map.fetch(env, var_name) do
      {:ok, value} ->
        {:ok, value}

      :error ->
        {:error, InvalidConfigurationError.exception(key: var_name)}
    end
  end

  @spec fetch_http_port(map, String.t(), port_number) ::
          {:ok, port_number} | {:error, InvalidConfigurationError.t()}
  defp fetch_http_port(env, var_name, default_port) when is_integer(default_port) do
    case Map.fetch(env, var_name) do
      {:ok, http_port_str} ->
        case Integer.parse(http_port_str) do
          {port_number, _} when port_number >= 0 ->
            {:ok, port_number}

          _ ->
            {:error, InvalidConfigurationError.exception(key: var_name)}
        end

      :error ->
        {:ok, default_port}
    end
  end
end
