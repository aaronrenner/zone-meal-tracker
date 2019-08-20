defmodule ZoneMealTrackerWeb.SessionController.LoginForm do
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

  def changeset(form \\ %__MODULE__{}, params \\ %{}) do
    form
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
  end

  @spec run(map) :: {:ok, User.t()} | {:error, Changeset.t()}
  def run(params) do
    changeset = changeset(%__MODULE__{}, params)

    with {:ok, form} <- apply_action(changeset, :insert) do
      lookup_user(form, changeset)
    end
  end

  @spec lookup_user(t, Changeset.t()) :: {:ok, User.t()} | {:error, Changeset.t()}
  defp lookup_user(%__MODULE__{email: email, password: password}, changeset) do
    case ZoneMealTracker.fetch_user_by_email_and_password(email, password) do
      {:ok, %User{} = user} ->
        {:ok, user}

      {:error, :not_found} ->
        {:error, changeset}
    end
  end
end
