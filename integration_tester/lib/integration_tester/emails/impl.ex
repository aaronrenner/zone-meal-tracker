defmodule IntegrationTester.Emails.Impl do
  @moduledoc false

  @type email_opt :: {:to, [String.t()]} | {:subject, String.t()}

  @callback assert_email_delivered_with([email_opt]) :: :ok | no_return
end
