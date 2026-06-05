defmodule FindStatePlatesWeb.UserRegistrationController do
  use FindStatePlatesWeb, :controller

  alias FindStatePlates.Accounts
  alias FindStatePlates.Accounts.User
  alias FindStatePlatesWeb.UserAuth

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome to Find State Plates!")
        |> UserAuth.log_in_user(user)

      {:error, changeset} ->
        render(conn, :new, changeset: Map.put(changeset, :action, :insert))
    end
  end
end
