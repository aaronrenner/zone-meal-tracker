defmodule IntegrationTester.Emails.BambooImpl do
  @moduledoc false

  import Bamboo.Test

  @behaviour IntegrationTester.Emails.Impl

  @type email_opt :: {:to, [String.t()]} | {:subject, String.t()}

  @impl true
  @spec assert_email_delivered_with([email_opt]) :: :ok | no_return
  def assert_email_delivered_with(opts) do
    Bamboo.Test.assert_email_delivered_with(opts)
  end
end
