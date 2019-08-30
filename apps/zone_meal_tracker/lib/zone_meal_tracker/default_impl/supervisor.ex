defmodule ZoneMealTracker.DefaultImpl.Supervisor do
  @moduledoc false
  use Supervisor

  alias ZoneMealTracker.DefaultImpl.AccountStore

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      AccountStore
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
