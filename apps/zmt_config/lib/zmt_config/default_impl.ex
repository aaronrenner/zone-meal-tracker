defmodule ZMTConfig.DefaultImpl do
  @moduledoc false

  alias ZMTConfig.Config

  @behaviour ZMTConfig.Impl

  @impl true
  @spec get_config() :: Config.t()
  def get_config do
    env = Application.get_all_env(:zmt_config)
    port = Keyword.get(env, :http_port, 4000)
    url_setting = Keyword.get(env, :url, [])

    uri =
      url_setting
      |> Keyword.put_new(:host, "localhost")
      |> Keyword.put_new(:port, port)
      |> (&struct!(URI, &1)).()

    %Config{
      http_port: port,
      url: url_setting,
      http_uri_base: %URI{uri | scheme: "http"}
    }
  end
end
