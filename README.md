# Find State Plates

A Phoenix + LiveView "License Plate Tracker" application for recording which state plates you have spotted on each trip.

## Stack

- Elixir + Phoenix Framework
- Phoenix LiveView for interactive UI
- PostgreSQL via Ecto
- Cookie/session authentication patterned after `phx.gen.auth`

## Project structure

```text
lib/
  find_state_plates/
    accounts/        # user and session-token schemas
    trips/           # trip + checked-state schemas
    accounts.ex      # authentication context
    trips.ex         # trip management context
    states.ex        # static state catalog + trivia + SVG tile positions
  find_state_plates_web/
    components/
      state_map.ex   # SVG tile map component
    controllers/
      user_*         # registration/session controllers
    live/trip_live/  # trip management and tracker LiveViews
    user_auth.ex     # auth plug + LiveView on_mount hooks
priv/repo/migrations/
  *_create_users_auth_tables.exs
  *_create_trips_and_checked_states.exs
test/
  find_state_plates/             # context coverage
  find_state_plates_web/live/    # LiveView integration coverage
  support/fixtures/              # reusable test data
```

## Database schema

- `users` has many `trips`
- `users_tokens` stores hashed session tokens for cookie-based auth
- `trips` belongs to `users`
- `checked_states` belongs to `trips`

`checked_states` stores:

- `state_code`
- `state_name`
- `trivia`
- `seen_at`

The state catalog itself is static application data in `FindStatePlates.States`, which keeps the tracker lightweight and avoids a separate lookup table for all 50 states.

## Interactive views

- `/trips` — authenticated LiveView for trip creation and trip list
- `/trips/:id` — authenticated LiveView with:
  - alphabetical checklist of states
  - SVG tile-map component using `phx-click`
  - trivia modal for the selected state

## Testing strategy for 90% coverage

The repository is configured to enforce a 90% global coverage threshold in `mix.exs`:

```elixir
test_coverage: [summary: [threshold: 90]]
```

Run tests with coverage locally:

```bash
mix test --cover
```

During iteration, prefer focused validation on the files you touched before running the final coverage pass:

```bash
mix test test/find_state_plates/trips_test.exs test/find_state_plates_web/live/trip_live_test.exs
```

To keep coverage focused on application behavior, a `.coverignore` file is included for framework-generated glue like endpoint, telemetry, and layout wrappers.

### Recommended test split

1. **Context tests first** (`test/find_state_plates/*_test.exs`)
   - registration and session token logic
   - trip creation
   - state toggling and per-trip state aggregation
2. **LiveView integration tests** (`test/find_state_plates_web/live/*`)
   - create a trip from the LiveView
   - toggle a state from the checklist or map
   - open trivia modal content
3. **Controller smoke tests**
   - public landing page
   - auth redirects as needed

## CI coverage enforcement

The workflow at `.github/workflows/ci.yml` provisions PostgreSQL, runs migrations, and executes:

```bash
mix test --cover
```

Because the threshold is defined in `mix.exs`, CI will fail automatically if total coverage drops below 90%.

## Coverage exclusions

This project configures coverage exclusions in `mix.exs` via `test_coverage: [ignore_modules: ...]` (the mechanism used by `mix test --cover`).

Avoid excluding context modules or LiveViews, since those are the key paths that should stay under coverage pressure.

## Sample SVG LiveView component

The `FindStatePlatesWeb.StateMap` component shows the intended approach for the map without heavy JavaScript libraries:

```elixir
def state_map(assigns) do
  ~H"""
  <svg viewBox="0 0 920 460">
    <g :for={state <- @states}>
      <rect
        x={state.col * 54 + 20}
        y={state.row * 46 + 20}
        width="44"
        height="36"
        phx-click="toggle_state"
        phx-value-state={state.code}
      />
      <text x={state.col * 54 + 42} y={state.row * 46 + 43} text-anchor="middle">
        <%= state.code %>
      </text>
    </g>
  </svg>
  """
end
```

Each SVG shape is a LiveView event target, so state updates remain server-driven and instantly re-render without introducing a client-side mapping framework.
