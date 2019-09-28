defmodule ZMTConfig.DefaultImpl do
  @moduledoc false

  alias ZMTConfig.Config
  alias ZMTConfig.InvalidConfigurationError

  @behaviour ZMTConfig.Impl

  @impl true
  @spec fetch_config() :: {:ok, Config.t()} | {:error, InvalidConfigurationError.t()}
  def fetch_config do
    env = Application.get_all_env(:zmt_config)

    case Keyword.fetch(env, :secret_key_base) do
      {:ok, secret_key_base} ->
        port = Keyword.get(env, :http_port, 4000)
        url_setting = Keyword.get(env, :url, [])

        uri =
          url_setting
          |> Keyword.put_new(:host, "localhost")
          |> Keyword.put_new(:port, port)
          |> (&struct!(URI, &1)).()

        config = %Config{
          secret_key_base: secret_key_base,
          http_port: port,
          url: url_setting,
          http_uri_base: %URI{uri | scheme: "http"}
        }

        {:ok, config}

      :error ->
        {:error, InvalidConfigurationError.exception(key: :secret_key_base)}
    end
  end
end
