defmodule ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl.Login do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset
  alias Ecto.UUID

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "logins" do
    field :user_id, :binary_id
    timestamps(type: :utc_datetime)
  end

  @type t :: %__MODULE__{
          id: String.t() | nil,
          user_id: String.t() | nil,
          inserted_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }

  @spec changeset(t, map) :: Changeset.t()
  def changeset(login, attrs) do
    login
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
    |> validate_uuid(:user_id)
    |> foreign_key_constraint(:user_id)
  end

  @spec validate_uuid(Changeset.t(), atom) :: Changeset.t()
  defp validate_uuid(%Changeset{} = changeset, field) when is_atom(field) do
    validate_change(changeset, field, fn field, value ->
      case UUID.cast(value) do
        {:ok, _uuid} ->
          []

        :error ->
          [{field, "is invalid"}]
      end
    end)
  end
end
