defmodule ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl.DataCase do
  @moduledoc false
  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      alias ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  setup tags do
    :ok = Sandbox.checkout(ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl.Repo)

    unless tags[:async] do
      Sandbox.mode(
        ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl.Repo,
        {:shared, self()}
      )
    end

    :ok
  end
end
