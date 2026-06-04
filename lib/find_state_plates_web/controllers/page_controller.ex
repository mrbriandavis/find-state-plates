defmodule FindStatePlatesWeb.PageController do
  use FindStatePlatesWeb, :controller

  def home(%Plug.Conn{assigns: %{current_user: current_user}} = conn, _params) when not is_nil(current_user) do
    redirect(conn, to: ~p"/trips")
  end

  def home(conn, _params) do
    render(conn, :home)
  end
end
