defmodule ZoneMealTracker.DefaultImpl.AccountStore.Supervisor do
  @moduledoc false
  use Supervisor

  alias ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      {PostgresImpl, name: PostgresImpl}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
