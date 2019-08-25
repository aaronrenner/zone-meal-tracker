defmodule ZoneMealTracker.DefaultImpl.Notifications.DefaultImpl.NotificationPreferenceStore.PostgresImpl.Supervisor do
  @moduledoc false
  use Supervisor

  alias ZoneMealTracker.DefaultImpl.Notifications.DefaultImpl.NotificationPreferenceStore.PostgresImpl.Repo

  def start_link(init_arg) do
    {start_opts, init_opts} = Keyword.split(init_arg, [:name])

    Supervisor.start_link(__MODULE__, init_opts, start_opts)
  end

  @impl true
  def init(_init_opts) do
    children = [
      Repo
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
