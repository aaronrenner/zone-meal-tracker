defmodule ZMTConfig do
  @moduledoc """
  Internal API retrieving application-wide config.
  """

  alias ZMTConfig.Config
  alias ZMTConfig.DefaultImpl
  alias ZMTConfig.InvalidConfigurationError

  @behaviour ZMTConfig.Impl

  @doc """
  Gets the current config
  """
  @impl true
  @spec fetch_config() :: {:ok, Config.t()} | {:error, InvalidConfigurationError.t()}
  def fetch_config do
    current_impl().fetch_config()
  end

  defp current_impl do
    Application.get_env(:zmt_config, :impl, DefaultImpl)
  end
end
