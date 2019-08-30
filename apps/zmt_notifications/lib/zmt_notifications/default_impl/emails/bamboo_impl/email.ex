defmodule ZMTNotifications.DefaultImpl.Emails.BambooImpl.Email do
  @moduledoc false

  import Bamboo.Email
  import ZMTNotifications.DefaultImpl.Emails.Guards

  alias Bamboo.Email
  alias ZMTNotifications.DefaultImpl.Emails

  @spec welcome_email(Emails.email()) :: Email.t()
  def welcome_email(email_address) when is_email(email_address) do
    new_email(
      to: email_address,
      from: "aaron@zonemealtracker.com",
      subject: "Welcome to ZoneMealTracker",
      html_body: "Hi, there! Thanks for joining.",
      text_body: "Hi, there! Thanks for joining."
    )
  end
end
