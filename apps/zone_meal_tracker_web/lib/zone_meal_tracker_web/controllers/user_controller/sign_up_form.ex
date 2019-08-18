defmodule ZoneMealTrackerWeb.UserController.SignUpForm do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset
  alias ZoneMealTracker.User

  @type t :: %__MODULE__{
          username: String.t() | nil,
          password: String.t() | nil
        }

  @primary_key false
  embedded_schema do
    field :username, :string
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
    |> cast(params, [:username, :password])
    |> validate_required([:username, :password])
    |> validate_length(:password, min: 8)
  end

  @spec register_user(t, Changeset.t()) :: {:ok, User.t()} | {:error, Changeset.t()}
  defp register_user(%__MODULE__{username: username, password: password}, changeset) do
    case ZoneMealTracker.register_user(username, password) do
      {:ok, %User{} = user} ->
        {:ok, user}

      {:error, :username_already_registered} ->
        changeset
        |> add_error(:username, "is already taken")
        |> apply_action(:insert)
    end
  end
end
