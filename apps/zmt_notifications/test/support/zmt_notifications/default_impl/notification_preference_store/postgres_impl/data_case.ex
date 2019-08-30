defmodule ZMTNotifications.DefaultImpl.NotificationPreferenceStore.PostgresImpl.DataCase do
  @moduledoc false
  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      alias ZMTNotifications.DefaultImpl.NotificationPreferenceStore.PostgresImpl.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  setup tags do
    :ok =
      Sandbox.checkout(ZMTNotifications.DefaultImpl.NotificationPreferenceStore.PostgresImpl.Repo)

    unless tags[:async] do
      Sandbox.mode(
        ZMTNotifications.DefaultImpl.NotificationPreferenceStore.PostgresImpl.Repo,
        {:shared, self()}
      )
    end

    :ok
  end
end
