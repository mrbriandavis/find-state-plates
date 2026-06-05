defmodule FindStatePlatesWeb.UserAuth do
  use FindStatePlatesWeb, :verified_routes

  import Plug.Conn
  import Phoenix.Controller
  import Phoenix.LiveView

  alias FindStatePlates.Accounts
  alias FindStatePlatesWeb.Endpoint

  def init(opts), do: opts

  def call(conn, :fetch_current_user), do: fetch_current_user(conn, [])

  def call(conn, :redirect_if_user_is_authenticated),
    do: redirect_if_user_is_authenticated(conn, [])

  def call(conn, :require_authenticated_user), do: require_authenticated_user(conn, [])

  def log_in_user(conn, user) do
    user_token = Accounts.generate_user_session_token(user)
    user_return_to = get_session(conn, :user_return_to)

    conn
    |> renew_session()
    |> put_session(:user_token, user_token)
    |> put_session(:live_socket_id, "users_sessions:#{Base.url_encode64(user_token)}")
    |> redirect(to: user_return_to || ~p"/trips")
  end

  def log_out_user(conn) do
    if user_token = get_session(conn, :user_token) do
      Accounts.delete_user_session_token(user_token)
    end

    if live_socket_id = get_session(conn, :live_socket_id) do
      Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> renew_session()
    |> redirect(to: ~p"/")
  end

  def fetch_current_user(conn, _opts) do
    user =
      conn
      |> get_session(:user_token)
      |> case do
        nil -> nil
        token -> Accounts.get_user_by_session_token(token)
      end

    assign(conn, :current_user, user)
  end

  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: ~p"/trips")
      |> halt()
    else
      conn
    end
  end

  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> maybe_store_return_to()
      |> put_flash(:error, "You must log in to access that page.")
      |> redirect(to: ~p"/users/log_in")
      |> halt()
    end
  end

  def on_mount(:mount_current_user, _params, session, socket) do
    {:cont,
     assign(
       socket,
       :current_user,
       session["user_token"] && Accounts.get_user_by_session_token(session["user_token"])
     )}
  end

  def on_mount(:ensure_authenticated, _params, session, socket) do
    socket =
      assign(
        socket,
        :current_user,
        session["user_token"] && Accounts.get_user_by_session_token(session["user_token"])
      )

    if socket.assigns.current_user do
      {:cont, socket}
    else
      {:halt,
       socket
       |> put_flash(:error, "You must log in to access that page.")
       |> redirect(to: ~p"/users/log_in")}
    end
  end

  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  defp maybe_store_return_to(%Plug.Conn{method: "GET"} = conn) do
    put_session(conn, :user_return_to, current_path(conn))
  end

  defp maybe_store_return_to(conn), do: conn
end
