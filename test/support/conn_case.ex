defmodule FindStatePlatesWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by tests that require setting up a connection.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      @endpoint FindStatePlatesWeb.Endpoint

      use FindStatePlatesWeb, :verified_routes

      import Plug.Conn
      import Phoenix.ConnTest
      import FindStatePlatesWeb.ConnCase
      import FindStatePlates.AccountsFixtures
      import FindStatePlates.TripsFixtures
    end
  end

  setup tags do
    FindStatePlates.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  def register_and_log_in_user(%{conn: conn}) do
    user = FindStatePlates.AccountsFixtures.user_fixture()
    %{conn: log_in_user(conn, user), user: user}
  end

  def log_in_user(conn, user) do
    token = FindStatePlates.Accounts.generate_user_session_token(user)

    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Plug.Conn.put_session(:user_token, token)
  end
end
