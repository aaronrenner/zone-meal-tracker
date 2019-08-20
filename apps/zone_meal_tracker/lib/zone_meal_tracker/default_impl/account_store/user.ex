defmodule ZoneMealTracker.DefaultImpl.AccountStore.User do
  @moduledoc false

  defstruct [:id, :email]

  @type email :: String.t()
  @type password :: String.t()

  @type id :: String.t()
  @type t :: %__MODULE__{
          id: id,
          email: email
        }
end
