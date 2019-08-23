defmodule ZMTConfig.Impl do
  @moduledoc false

  alias ZMTConfig.Config

  @callback get_config() :: Config.t()
end
