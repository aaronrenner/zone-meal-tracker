Mox.defmock(ZoneMealTracker.DefaultImpl.MockAccountStore,
  for: ZoneMealTracker.DefaultImpl.AccountStore.Impl
)

Application.put_env(
  :zone_meal_tracker,
  :account_store,
  ZoneMealTracker.DefaultImpl.MockAccountStore
)

Mox.defmock(ZoneMealTracker.DefaultImpl.MockNotifications,
  for: ZoneMealTracker.DefaultImpl.Notifications.Impl
)

Application.put_env(
  :zone_meal_tracker,
  :notifications_impl,
  ZoneMealTracker.DefaultImpl.MockNotifications
)

Mox.defmock(ZoneMealTracker.DefaultImpl.Notifications.DefaultImpl.MockNotificationPreferenceStore,
  for: ZoneMealTracker.DefaultImpl.Notifications.DefaultImpl.NotificationPreferenceStore.Impl
)

Application.put_env(
  :zone_meal_tracker,
  :notification_preference_store_impl,
  ZoneMealTracker.DefaultImpl.Notifications.DefaultImpl.MockNotificationPreferenceStore
)

Mox.defmock(ZoneMealTracker.DefaultImpl.Notifications.DefaultImpl.MockEmails,
  for: ZoneMealTracker.DefaultImpl.Notifications.DefaultImpl.Emails.Impl
)

Application.put_env(
  :zone_meal_tracker,
  :emails_impl,
  ZoneMealTracker.DefaultImpl.Notifications.DefaultImpl.MockEmails
)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(
  ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl.Repo,
  :manual
)
