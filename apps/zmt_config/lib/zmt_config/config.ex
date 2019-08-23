defmodule ZMTConfig.Config do
  @moduledoc """
  Configuration struct with data to be used by other apps
  """

  defstruct [
    :http_port,
    :url,
    :http_uri_base
  ]

  @type t :: %__MODULE__{
          http_port: non_neg_integer(),
          url: list(),
          http_uri_base: URI.t()
        }
end
