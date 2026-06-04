defmodule FindStatePlates.TripsTest do
  use FindStatePlates.DataCase, async: true

  alias FindStatePlates.Trips
  alias FindStatePlates.Trips.Trip

  import FindStatePlates.AccountsFixtures
  import FindStatePlates.TripsFixtures

  describe "create_trip/2" do
    test "creates a trip for a user" do
      user = user_fixture()

      assert {:ok, %Trip{} = trip} =
               Trips.create_trip(user, %{name: "Mountain drive", started_on: ~D[2026-07-04]})

      assert trip.user_id == user.id
      assert trip.name == "Mountain drive"
    end
  end

  describe "toggle_checked_state/2" do
    test "marks and unmarks a state for a trip" do
      user = user_fixture()
      trip = trip_fixture(user)

      assert {:ok, :checked} = Trips.toggle_checked_state(trip, "CA")
      assert Trips.state_seen?(trip, "CA")

      trip = Trips.get_trip!(user, trip.id)
      assert {:ok, :unchecked} = Trips.toggle_checked_state(trip, "CA")
      refute Trips.state_seen?(trip, "CA")
    end

    test "returns an error for an unknown state" do
      trip = trip_fixture(user_fixture())
      assert {:error, :unknown_state} = Trips.toggle_checked_state(trip, "XX")
    end
  end

  describe "states_for_trip/1" do
    test "merges catalog data with seen states" do
      user = user_fixture()
      trip = trip_fixture(user)
      assert {:ok, :checked} = Trips.toggle_checked_state(trip, "TX")

      states =
        user
        |> Trips.get_trip!(trip.id)
        |> Trips.states_for_trip()

      assert Enum.find(states, &(&1.code == "TX")).seen
      refute Enum.find(states, &(&1.code == "CA")).seen
    end
  end
end
