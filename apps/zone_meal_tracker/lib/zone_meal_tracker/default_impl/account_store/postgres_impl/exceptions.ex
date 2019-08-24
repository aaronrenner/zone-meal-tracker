defmodule ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl.InvalidDataError do
  @moduledoc false

  @type t :: %__MODULE__{
          message: String.t(),
          errors: term
        }

  defexception [:message, :errors]

  def exception(opts) do
    errors = Keyword.fetch!(opts, :errors)

    message = """
    unable to persist record because data is invalid
    errors:
    #{inspect(errors)}
    """

    %__MODULE__{message: message, errors: errors}
  end
end
