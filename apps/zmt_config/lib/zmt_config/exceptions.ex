defmodule ZMTConfig.InvalidConfigurationError do
  @moduledoc """
  Indicates there was an issue with the configuration
  """

  @type t :: %__MODULE__{
          message: String.t(),
          key: term
        }

  defexception [:message, :key]

  def exception(opts) do
    key = Keyword.fetch!(opts, :key)

    message = "invalid configuration setting #{inspect(key)}"

    %__MODULE__{message: message, key: key}
  end
end
