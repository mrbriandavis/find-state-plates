defmodule FindStatePlates.TripsFixtures do
  @moduledoc false

  alias FindStatePlates.Trips

  def trip_fixture(user, attrs \\ %{}) do
    {:ok, trip} =
      attrs
      |> Enum.into(%{name: "Summer road trip", started_on: ~D[2026-06-01], notes: "Cross-country plate spotting"})
      |> Trips.create_trip(user)

    trip
  end
end
