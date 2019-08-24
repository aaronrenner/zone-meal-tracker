defmodule ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl.Repo.Migrations.CreateLogins do
  use Ecto.Migration

  def change do
    create table(:logins, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end
  end
end
