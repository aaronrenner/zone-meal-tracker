Mox.defmock(ZMTNotifications.DefaultImpl.MockNotificationPreferenceStore,
  for: ZMTNotifications.DefaultImpl.NotificationPreferenceStore.Impl
)

Application.put_env(
  :zmt_notifications,
  :notification_preference_store_impl,
  ZMTNotifications.DefaultImpl.MockNotificationPreferenceStore
)

Mox.defmock(ZMTNotifications.DefaultImpl.MockEmails,
  for: ZMTNotifications.DefaultImpl.Emails.Impl
)

Application.put_env(
  :zmt_notifications,
  :emails_impl,
  ZMTNotifications.DefaultImpl.MockEmails
)

ExUnit.start()
