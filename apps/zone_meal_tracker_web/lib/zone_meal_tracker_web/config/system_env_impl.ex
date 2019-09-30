defmodule ZoneMealTrackerWeb.Config.SystemEnvImpl do
  @moduledoc false

  alias ZoneMealTrackerWeb.Config.Impl
  alias ZoneMealTrackerWeb.Config.InvalidConfigurationError

  @behaviour ZoneMealTrackerWeb.Config.Impl

  @type url_settings :: Impl.url_settings()
  @type port_number :: Impl.port_number()

  @env_var_http_port "ZMT_HTTP_PORT"
  @env_var_secret_key_base "ZMT_SECRET_KEY_BASE"

  @port_number_min 0
  @port_number_max 65_535

  @impl true
  @spec fetch_http_port() :: {:ok, port_number} | {:error, InvalidConfigurationError.t()}
  def fetch_http_port do
    with {:ok, port_number_string} <- System.fetch_env(@env_var_http_port),
         {:ok, port_number} <- parse_port_number(port_number_string) do
      {:ok, port_number}
    else
      _ ->
        {:error, InvalidConfigurationError.exception(setting: @env_var_http_port)}
    end
  end

  @impl true
  @spec fetch_url_settings() :: {:ok, url_settings}
  def fetch_url_settings do
    {:ok, []}
  end

  @impl true
  @spec fetch_secret_key_base() :: {:ok, String.t()} | {:error, InvalidConfigurationError.t()}
  def fetch_secret_key_base do
    case System.fetch_env(@env_var_secret_key_base) do
      {:ok, secret_key_base} ->
        {:ok, secret_key_base}

      :error ->
        {:error, InvalidConfigurationError.exception(setting: @env_var_secret_key_base)}
    end
  end

  @spec parse_port_number(String.t()) :: {:ok, port_number} | :error
  def parse_port_number(port_number_string) do
    case Integer.parse(port_number_string) do
      {port_number, ""}
      when port_number >= @port_number_min and port_number <= @port_number_max ->
        {:ok, port_number}

      _ ->
        :error
    end
  end
end
