defmodule ZoneMealTrackerWeb.Config.InvalidConfigurationError do
  @moduledoc false

  @type t :: %__MODULE__{
          setting: term,
          message: String.t()
        }

  defexception [:setting, :message]

  def exception(values) do
    setting = Keyword.fetch!(values, :setting)

    message = """
    invalid configuration for setting #{inspect(setting)}
    """

    %__MODULE__{message: message, setting: setting}
  end
end
