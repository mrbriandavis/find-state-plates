defmodule FindStatePlates.Repo do
  use Ecto.Repo,
    otp_app: :find_state_plates,
    adapter: Ecto.Adapters.Postgres
end
