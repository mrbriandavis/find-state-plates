defmodule FindStatePlates.Trips do
  import Ecto.Query, warn: false

  alias FindStatePlates.Accounts.User
  alias FindStatePlates.Repo
  alias FindStatePlates.States
  alias FindStatePlates.Trips.{CheckedState, Trip}

  def list_trips(%User{id: user_id}) do
    Trip
    |> where([trip], trip.user_id == ^user_id)
    |> order_by([trip], desc: trip.inserted_at)
    |> preload(:checked_states)
    |> Repo.all()
  end

  def get_trip!(%User{id: user_id}, id) do
    Trip
    |> where([trip], trip.id == ^id and trip.user_id == ^user_id)
    |> preload(:checked_states)
    |> Repo.one!()
  end

  def create_trip(%User{} = user, attrs) do
    %Trip{}
    |> Trip.changeset(Map.put(attrs, :user_id, user.id))
    |> Repo.insert()
  end

  def change_trip(%Trip{} = trip, attrs \\ %{}) do
    Trip.changeset(trip, attrs)
  end

  def states_for_trip(%Trip{} = trip) do
    trip = Repo.preload(trip, :checked_states)
    seen_by_code = Map.new(trip.checked_states, &{&1.state_code, &1})

    States.all()
    |> Enum.map(fn state ->
      case Map.get(seen_by_code, state.code) do
        nil -> Map.merge(state, %{seen: false, seen_at: nil})
        checked_state -> Map.merge(state, %{seen: true, seen_at: checked_state.seen_at})
      end
    end)
  end

  def toggle_checked_state(%Trip{} = trip, state_code) do
    trip = Repo.preload(trip, :checked_states)
    state_code = String.upcase(state_code)

    case States.get(state_code) do
      nil ->
        {:error, :unknown_state}

      state ->
        case Enum.find(trip.checked_states, &(&1.state_code == state.code)) do
          nil ->
            %CheckedState{}
            |> CheckedState.changeset(%{
              trip_id: trip.id,
              state_code: state.code,
              state_name: state.name,
              trivia: state.trivia,
              seen_at: DateTime.utc_now() |> DateTime.truncate(:second)
            })
            |> Repo.insert()
            |> case do
              {:ok, _checked_state} -> {:ok, :checked}
              {:error, changeset} -> {:error, changeset}
            end

          checked_state ->
            case Repo.delete(checked_state) do
              {:ok, _checked_state} -> {:ok, :unchecked}
              {:error, changeset} -> {:error, changeset}
            end
        end
    end
  end

  def state_seen?(%Trip{} = trip, state_code) do
    trip
    |> states_for_trip()
    |> Enum.any?(&(&1.code == String.upcase(state_code) and &1.seen))
  end
end
