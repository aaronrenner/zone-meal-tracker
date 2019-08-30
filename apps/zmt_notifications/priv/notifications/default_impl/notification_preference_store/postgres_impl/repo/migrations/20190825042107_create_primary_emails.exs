defmodule ZMTNotifications.DefaultImpl.NotificationPreferenceStore.PostgresImpl.Repo.Migrations.CreatePrimaryEmails do
  # credo:disable-for-previous-line Credo.Check.Readability.MaxLineLength
  use Ecto.Migration

  def change do
    create table(:primary_emails, primary_key: false) do
      add :user_id, :uuid, primary_key: true
      add :email, :string, null: false
    end
  end
end
