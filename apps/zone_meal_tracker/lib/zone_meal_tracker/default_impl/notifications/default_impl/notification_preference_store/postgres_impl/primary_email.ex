defmodule ZoneMealTracker.DefaultImpl.Notifications.DefaultImpl.NotificationPreferenceStore.PostgresImpl.PrimaryEmail do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset

  @primary_key {:user_id, :binary_id, []}

  schema "primary_emails" do
    field :email, :string
  end

  @type t :: %__MODULE__{
          user_id: String.t() | nil,
          email: String.t() | nil
        }

  @spec changeset(t, map) :: Changeset.t()
  def changeset(data, params) do
    data
    |> cast(params, [:user_id, :email])
    |> validate_required([:user_id, :email])
  end
end
