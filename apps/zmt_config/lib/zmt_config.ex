defmodule ZMTConfig do
  @moduledoc """
  Internal API retrieving application-wide config.
  """

  alias ZMTConfig.Config
  alias ZMTConfig.DefaultImpl

  @behaviour ZMTConfig.Impl

  @doc """
  Gets the current config
  """
  @impl true
  @spec get_config() :: Config.t()
  def get_config do
    current_impl().get_config()
  end

  defp current_impl do
    Application.get_env(:zmt_config, :impl, DefaultImpl)
  end
end
