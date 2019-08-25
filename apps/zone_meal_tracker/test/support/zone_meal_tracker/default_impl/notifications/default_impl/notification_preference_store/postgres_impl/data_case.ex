defmodule ZoneMealTracker.DefaultImpl.Notifications.DefaultImpl.NotificationPreferenceStore.PostgresImpl.DataCase do
  @moduledoc false
  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      alias ZoneMealTracker.DefaultImpl.Notifications.DefaultImpl.NotificationPreferenceStore.PostgresImpl.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  setup tags do
    :ok =
      Sandbox.checkout(
        ZoneMealTracker.DefaultImpl.Notifications.DefaultImpl.NotificationPreferenceStore.PostgresImpl.Repo
      )

    unless tags[:async] do
      Sandbox.mode(
        ZoneMealTracker.DefaultImpl.Notifications.DefaultImpl.NotificationPreferenceStore.PostgresImpl.Repo,
        {:shared, self()}
      )
    end

    :ok
  end
end
