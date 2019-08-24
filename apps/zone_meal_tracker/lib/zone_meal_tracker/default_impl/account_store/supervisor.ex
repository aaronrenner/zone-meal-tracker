defmodule ZoneMealTracker.DefaultImpl.AccountStore.Supervisor do
  @moduledoc false
  use Supervisor

  alias ZoneMealTracker.DefaultImpl.AccountStore.InMemoryImpl
  alias ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      {InMemoryImpl, name: InMemoryImpl},
      {PostgresImpl, name: PostgresImpl}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
