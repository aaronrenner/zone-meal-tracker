defmodule ZoneMealTrackerWeb.FormCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  alias Ecto.Changeset

  using do
    quote do
      import unquote(__MODULE__)
    end
  end

  @doc """
  A helper that transform changeset errors to a map of messages.

  assert {:error, changeset} = Accounts.create_user(%{password: "short"})
  assert "password is too short" in errors_on(changeset).password
  assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Changeset.traverse_errors(changeset, fn {message, opts} ->
      Enum.reduce(opts, message, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
