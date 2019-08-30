defmodule ZMTNotifications.DefaultImpl.Emails.BambooImplTest do
  use ExUnit.Case, async: true
  use Bamboo.Test

  alias ZMTNotifications.DefaultImpl.Emails.BambooImpl

  @moduletag :capture_log

  test "send_welcome_email/1 sends an email and returns :ok" do
    email_address = "hello@world.com"

    assert :ok = BambooImpl.send_welcome_email(email_address)

    assert_email_delivered_with(
      to: [email_address],
      subject: "Welcome to ZoneMealTracker"
    )
  end
end
