defmodule ZoneMealTracker.User do
  @moduledoc """
  User struct
  """

  @type id :: String.t()
  @type username :: String.t()
  @type t :: %__MODULE__{
          id: id,
          username: username
        }

  defstruct [:id, :username]
end
