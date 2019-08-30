defmodule ZMTNotifications.DefaultImpl.NotificationPreferenceStore.PostgresImplTest do
  use ZMTNotifications.DefaultImpl.NotificationPreferenceStore.PostgresImpl.DataCase,
    async: true

  alias Ecto.UUID

  alias ZMTNotifications.DefaultImpl.NotificationPreferenceStore.PostgresImpl

  @moduletag :capture_log

  test "putting and fetching an email with a valid user id" do
    user_id = UUID.generate()
    email = "abc@123.com"

    assert :ok = PostgresImpl.put_primary_email(user_id, email)

    assert {:ok, ^email} = PostgresImpl.fetch_primary_email(user_id)
  end

  test "putting an email multiple times overwrites the last email" do
    user_id = UUID.generate()

    :ok = PostgresImpl.put_primary_email(user_id, "first@test.com")
    :ok = PostgresImpl.put_primary_email(user_id, "second@test.com")
    :ok = PostgresImpl.put_primary_email(user_id, "last@test.com")

    assert {:ok, "last@test.com"} = PostgresImpl.fetch_primary_email(user_id)
  end

  test "fetch_primary_email/1 with an invalid user id" do
    assert {:error, :not_found} = PostgresImpl.fetch_primary_email("invalid")
  end

  test "fetch_primary_email/1 with an unknown user id" do
    assert {:error, :not_found} = PostgresImpl.fetch_primary_email(UUID.generate())
  end

  test "reset/2 with force: true, resets the data store" do
    user_id = UUID.generate()
    :ok = PostgresImpl.put_primary_email(user_id, "foo@bar.com")
    :ok = PostgresImpl.reset(force: true)

    assert {:error, :not_found} = PostgresImpl.fetch_primary_email(user_id)
  end

  test "reset/2 without force_true, raises an ArgumentError" do
    assert_raise ArgumentError, fn ->
      PostgresImpl.reset([])
    end
  end
end
