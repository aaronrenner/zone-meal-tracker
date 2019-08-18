defmodule ZoneMealTracker.DefaultImpl.AccountStore.Login do
  @moduledoc false

  alias ZoneMealTracker.DefaultImpl.AccountStore.User

  defstruct [:id, :user_id]

  @type id :: String.t()

  @type t :: %__MODULE__{
          id: id,
          user_id: User.id()
        }
end
