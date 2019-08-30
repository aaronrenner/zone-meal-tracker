defmodule ZMTNotifications.DefaultImpl.Emails.BambooImpl.Mailer do
  @moduledoc false
  use Bamboo.Mailer, otp_app: :zmt_notifications
end
