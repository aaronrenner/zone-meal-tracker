defmodule ZoneMealTracker.User do
  @moduledoc """
  User struct
  """

  @type id :: String.t()
  @type email :: String.t()
  @type t :: %__MODULE__{
          id: id,
          email: email
        }

  defstruct [:id, :email]
end
