defmodule ZMTConfig.Impl do
  @moduledoc false

  alias ZMTConfig.Config
  alias ZMTConfig.InvalidConfigurationError

  @callback fetch_config() :: {:ok, Config.t()} | {:error, InvalidConfigurationError.t()}
end
