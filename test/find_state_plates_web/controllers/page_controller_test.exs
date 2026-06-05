defmodule FindStatePlatesWeb.PageControllerTest do
  use FindStatePlatesWeb.ConnCase

  test "GET / renders the landing page", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Track every state plate you spot on the road"
  end
end
