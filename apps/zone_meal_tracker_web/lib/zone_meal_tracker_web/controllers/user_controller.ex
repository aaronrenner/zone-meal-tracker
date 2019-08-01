defmodule ZoneMealTrackerWeb.UserController do
  use ZoneMealTrackerWeb, :controller

  alias __MODULE__.SignUpForm

  def new(conn, _params) do
    changeset = SignUpForm.changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"sign_up_form" => sign_up_form_params}) do
    case SignUpForm.run(sign_up_form_params) do
      {:ok, _user} ->
        redirect(conn, to: Routes.page_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
