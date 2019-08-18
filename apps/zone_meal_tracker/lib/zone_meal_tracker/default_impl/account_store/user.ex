defmodule ZoneMealTracker.DefaultImpl.AccountStore.User do
  @moduledoc false

  defstruct [:id, :username]

  @type username :: String.t()
  @type password :: String.t()

  @type id :: String.t()
  @type t :: %__MODULE__{
          id: id,
          username: username
        }
end
