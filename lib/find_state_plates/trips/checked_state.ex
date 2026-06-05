defmodule FindStatePlates.Trips.CheckedState do
  use Ecto.Schema
  import Ecto.Changeset

  alias FindStatePlates.Trips.Trip

  schema "checked_states" do
    field :state_code, :string
    field :state_name, :string
    field :trivia, :string
    field :seen_at, :utc_datetime

    belongs_to :trip, Trip

    timestamps(type: :utc_datetime)
  end

  def changeset(checked_state, attrs) do
    checked_state
    |> cast(attrs, [:state_code, :state_name, :trivia, :seen_at, :trip_id])
    |> validate_required([:state_code, :state_name, :trivia, :seen_at, :trip_id])
    |> validate_inclusion(:state_code, FindStatePlates.States.codes())
    |> unique_constraint([:trip_id, :state_code])
    |> assoc_constraint(:trip)
  end
end
