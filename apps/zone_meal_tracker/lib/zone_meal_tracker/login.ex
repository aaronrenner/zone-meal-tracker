defmodule ZoneMealTracker.Login do
  @moduledoc """
  A login record
  """

  alias ZoneMealTracker.User

  @type id :: String.t()
  @type t :: %__MODULE__{
          id: id,
          user_id: User.id()
        }
  defstruct [:id, :user_id]
end
