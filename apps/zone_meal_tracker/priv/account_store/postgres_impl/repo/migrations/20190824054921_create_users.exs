defmodule ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :email, :string, null: false
      add :password_hash, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:users, [:email], unique: true)
  end
end
