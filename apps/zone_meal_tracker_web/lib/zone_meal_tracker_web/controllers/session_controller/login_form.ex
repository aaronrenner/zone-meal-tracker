defmodule ZoneMealTrackerWeb.SessionController.LoginForm do
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

  def changeset(form \\ %__MODULE__{}, params \\ %{}) do
    form
    |> cast(params, [:username, :password])
    |> validate_required([:username, :password])
  end

  @spec run(map) :: {:ok, User.t()} | {:error, Changeset.t()}
  def run(params) do
    changeset = changeset(%__MODULE__{}, params)

    with {:ok, form} <- apply_action(changeset, :insert) do
      lookup_user(form, changeset)
    end
  end

  @spec lookup_user(t, Changeset.t()) :: {:ok, User.t()} | {:error, Changeset.t()}
  defp lookup_user(%__MODULE__{username: username, password: password}, changeset) do
    case ZoneMealTracker.fetch_user_by_username_and_password(username, password) do
      {:ok, %User{} = user} ->
        {:ok, user}

      {:error, :not_found} ->
        {:error, changeset}
    end
  end
end
