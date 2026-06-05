defmodule FindStatePlates.Trips.Trip do
  use Ecto.Schema
  import Ecto.Changeset

  alias FindStatePlates.Accounts.User
  alias FindStatePlates.Trips.CheckedState

  schema "trips" do
    field :name, :string
    field :started_on, :date
    field :notes, :string

    belongs_to :user, User
    has_many :checked_states, CheckedState

    timestamps(type: :utc_datetime)
  end

  def changeset(trip, attrs) do
    trip
    |> cast(attrs, [:name, :started_on, :notes, :user_id])
    |> validate_required([:name, :user_id])
    |> validate_length(:name, max: 120)
    |> assoc_constraint(:user)
  end
end
