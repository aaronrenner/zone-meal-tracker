defmodule ZoneMealTrackerWeb.UserController.SignUpForm do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset
  alias ZoneMealTracker.User

  @type t :: %__MODULE__{
          email: String.t() | nil,
          password: String.t() | nil
        }

  @primary_key false
  embedded_schema do
    field :email, :string
    field :password, :string
  end

  @spec run(map) :: {:ok, User.t()} | {:error, Changeset.t()}
  def run(params) do
    changeset = changeset(%__MODULE__{}, params)

    with {:ok, request} <- apply_action(changeset, :insert) do
      register_user(request, changeset)
    end
  end

  @spec changeset(t, map()) :: Changeset.t()
  def changeset(request \\ %__MODULE__{}, params \\ %{}) do
    request
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_length(:password, min: 8)
  end

  @spec register_user(t, Changeset.t()) :: {:ok, User.t()} | {:error, Changeset.t()}
  defp register_user(%__MODULE__{email: email, password: password}, _changeset) do
    case ZoneMealTracker.register_user(email, password) do
      {:ok, %User{} = user} ->
        {:ok, user}
    end
  end
end
