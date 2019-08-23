defmodule ZoneMealTrackerWeb.PasswordController.ForgotPasswordForm do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset

  embedded_schema do
    field :email, :string
  end

  @type t :: %__MODULE__{
          email: String.t()
        }

  @type params :: map

  @spec(run(params) :: :ok, {:error, Changeset.t()})
  def run(params) do
    changeset = changeset(params)

    case apply_action(changeset, :insert) do
      {:ok, %__MODULE__{email: email}} ->
        :ok = ZoneMealTracker.send_forgot_password_link(email)
        :ok

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @spec changeset(params) :: Changeset.t()
  def changeset(params \\ %{}) when is_map(params) do
    %__MODULE__{}
    |> cast(params, [:email])
    |> validate_required(:email)
  end
end
