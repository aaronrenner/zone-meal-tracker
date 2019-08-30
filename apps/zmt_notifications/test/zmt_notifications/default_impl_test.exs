defmodule ZMTNotifications.DefaultImplTest do
  use ExUnit.Case, async: true

  import Mox

  alias ZMTNotifications.DefaultImpl
  alias ZMTNotifications.DefaultImpl.MockEmails
  alias ZMTNotifications.DefaultImpl.MockNotificationPreferenceStore

  setup [:set_mox_from_context, :verify_on_exit!]

  test "set_user_email/1 returns :ok when the email is valid" do
    user_id = "123"
    email = "foo@bar.com"

    expect(MockNotificationPreferenceStore, :put_primary_email, fn ^user_id, ^email ->
      :ok
    end)

    assert :ok = DefaultImpl.set_user_email(user_id, email)
  end

  test "set_user_email/1 returns {:error, :invalid_user_id} when the user_id is invalid" do
    user_id = "invalid"
    email = "foo@bar.com"

    expect(MockNotificationPreferenceStore, :put_primary_email, fn ^user_id, ^email ->
      {:error, :invalid_user_id}
    end)

    assert {:error, :invalid_user_id} = DefaultImpl.set_user_email(user_id, email)
  end

  test "send_welcome_message/1 sends the welcome email when an email id found for the userid" do
    user_id = "123"
    email = "foo@bar.com"

    expect(MockNotificationPreferenceStore, :fetch_primary_email, fn ^user_id ->
      {:ok, email}
    end)

    expect(MockEmails, :send_welcome_email, fn ^email ->
      :ok
    end)

    assert :ok = DefaultImpl.send_welcome_message(user_id)
  end

  test "send_welcome_message/1 does not send welcome email when user_id is not found" do
    user_id = "123"

    expect(MockNotificationPreferenceStore, :fetch_primary_email, fn ^user_id ->
      {:error, :not_found}
    end)

    assert {:error, :unknown_user_id} = DefaultImpl.send_welcome_message(user_id)
  end

  test "reset/1 with force: true, calls the various components resets" do
    expect(MockNotificationPreferenceStore, :reset, fn [force: true] -> :ok end)
    assert :ok = DefaultImpl.reset(force: true)
  end

  test "reset/1 without force: true, raises an exception" do
    assert_raise ArgumentError, fn ->
      DefaultImpl.reset([])
    end
  end
end
