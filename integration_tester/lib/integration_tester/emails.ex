defmodule IntegrationTester.Emails do
  @moduledoc """
  Primary API for working with emails
  """

  alias IntegrationTester.Emails.BambooImpl

  @behaviour IntegrationTester.Emails.Impl

  @type email_opt :: {:to, [String.t()]} | {:subject, String.t()}

  @impl true
  @spec assert_email_delivered_with([email_opt]) :: :ok | no_return
  def assert_email_delivered_with(opts) do
    impl().assert_email_delivered_with(opts)
  end

  defp impl do
    Application.get_env(:integration_tester, :emails_impl, BambooImpl)
  end
end
