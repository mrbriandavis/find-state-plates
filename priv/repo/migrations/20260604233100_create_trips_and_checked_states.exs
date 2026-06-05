defmodule FindStatePlates.Repo.Migrations.CreateTripsAndCheckedStates do
  use Ecto.Migration

  def change do
    create table(:trips) do
      add :name, :string, null: false
      add :started_on, :date
      add :notes, :text
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:trips, [:user_id])

    create table(:checked_states) do
      add :state_code, :string, null: false
      add :state_name, :string, null: false
      add :trivia, :text, null: false
      add :seen_at, :utc_datetime, null: false
      add :trip_id, references(:trips, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:checked_states, [:trip_id])
    create unique_index(:checked_states, [:trip_id, :state_code])
  end
end
