defmodule ZoneMealTrackerWeb.PasswordController do
  use ZoneMealTrackerWeb, :controller

  alias ZoneMealTrackerWeb.PasswordController.ForgotPasswordForm

  def new(conn, _params) do
    changeset = ForgotPasswordForm.changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params) do
    form_params = Map.get(params, "forgot_password_form", %{})

    case ForgotPasswordForm.run(form_params) do
      :ok ->
        conn
        |> put_flash(
          :info,
          """
          You will receive an email within the next
          few minutes. It contains instructions for
          changing your password.
          """
        )
        |> redirect(to: Routes.password_path(conn, :new))

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("new.html", changeset: changeset)
    end
  end
end
