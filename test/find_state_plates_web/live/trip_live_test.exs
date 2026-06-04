defmodule FindStatePlatesWeb.TripLiveTest do
  use FindStatePlatesWeb.ConnCase

  import Phoenix.LiveViewTest

  setup :register_and_log_in_user

  test "authenticated users can create trips", %{conn: conn, user: user} do
    {:ok, view, _html} = live(log_in_user(conn, user), ~p"/trips")

    view
    |> form("form", trip: %{name: "Pacific Coast", started_on: "2026-06-01", notes: "Check every west coast plate"})
    |> render_submit()

    assert render(view) =~ "Trip created."
    assert render(view) =~ "Pacific Coast"
  end

  test "trip page toggles states and shows trivia", %{conn: conn, user: user} do
    trip = trip_fixture(user)

    {:ok, view, _html} = live(log_in_user(conn, user), ~p"/trips/#{trip.id}")

    view
    |> element("button[phx-click=toggle_state][phx-value-state=CA]")
    |> render_click()

    assert render(view) =~ "1 of 50 states checked"

    view
    |> element("button[phx-click=show_trivia][phx-value-state=CA]")
    |> render_click()

    html = render(view)
    assert html =~ "State trivia"
    assert html =~ "California"
  end
end
