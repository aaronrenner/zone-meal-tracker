defmodule ZoneMealTrackerWeb.SessionController do
  use ZoneMealTrackerWeb, :controller

  alias ZoneMealTrackerWeb.Authentication
  alias ZoneMealTrackerWeb.SessionController.LoginForm

  def new(conn, _params) do
    changeset = LoginForm.changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"login_form" => login_form_params}) do
    case LoginForm.run(login_form_params) do
      {:ok, user} ->
        conn
        |> Authentication.log_in(user)
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Invalid username/password combination.")
        |> render("new.html", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    conn
    |> Authentication.log_out()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
