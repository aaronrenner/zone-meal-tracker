Mox.defmock(ZoneMealTracker.DefaultImpl.MockAccountStore,
  for: ZoneMealTracker.DefaultImpl.AccountStore.Impl
)

Application.put_env(
  :zone_meal_tracker,
  :account_store,
  ZoneMealTracker.DefaultImpl.MockAccountStore
)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(
  ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl.Repo,
  :manual
)
