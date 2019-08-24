defmodule ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :zone_meal_tracker,
    adapter: Ecto.Adapters.Postgres
end
