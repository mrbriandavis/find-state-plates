defmodule FindStatePlatesWeb.UserSessionController do
  use FindStatePlatesWeb, :controller

  alias FindStatePlates.Accounts
  alias FindStatePlatesWeb.UserAuth

  def new(conn, params) do
    render(conn, :new, form: to_form(%{"email" => params["email"] || ""}, as: :user))
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.get_user_by_email_and_password(email, password) do
      nil ->
        conn
        |> put_flash(:error, "Invalid email or password")
        |> render(:new, form: to_form(%{"email" => email}, as: :user))

      user ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> UserAuth.log_in_user(user)
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
