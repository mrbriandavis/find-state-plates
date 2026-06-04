defmodule FindStatePlatesWeb.TripLive.Show do
  use FindStatePlatesWeb, :live_view

  alias Phoenix.LiveView.JS
  alias FindStatePlates.Trips
  alias FindStatePlatesWeb.StateMap

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Trip tracker")
     |> assign(:selected_state_code, nil)
     |> load_trip(id)}
  end

  @impl true
  def handle_event("toggle_state", %{"state" => state_code}, socket) do
    case Trips.toggle_checked_state(socket.assigns.trip, state_code) do
      {:ok, _status} ->
        {:noreply, load_trip(socket, socket.assigns.trip.id, socket.assigns.selected_state_code)}

      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Unable to update that state right now.")}
    end
  end

  def handle_event("show_trivia", %{"state" => state_code}, socket) do
    {:noreply, load_trip(socket, socket.assigns.trip.id, state_code)}
  end

  def handle_event("close_trivia", _params, socket) do
    {:noreply, assign(socket, :selected_state_code, nil) |> assign(:selected_state, nil)}
  end

  defp load_trip(socket, id, selected_state_code \\ nil) do
    trip = Trips.get_trip!(socket.assigns.current_user, id)
    states = Trips.states_for_trip(trip)

    assign(socket,
      trip: trip,
      states: states,
      seen_count: Enum.count(states, & &1.seen),
      selected_state_code: selected_state_code,
      selected_state: Enum.find(states, &(&1.code == selected_state_code))
    )
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-8">
      <section class="flex flex-col gap-3 md:flex-row md:items-end md:justify-between">
        <div>
          <.link navigate={~p"/trips"} class="text-sm font-semibold text-zinc-500 underline underline-offset-4">
            Back to trips
          </.link>
          <h1 class="mt-2 text-3xl font-semibold tracking-tight text-zinc-900"><%= @trip.name %></h1>
          <p class="mt-2 text-sm leading-6 text-zinc-600">
            <%= @seen_count %> of <%= length(@states) %> states checked for this trip.
          </p>
        </div>
        <p :if={@trip.notes} class="max-w-xl text-sm leading-6 text-zinc-600"><%= @trip.notes %></p>
      </section>

      <section class="grid gap-8 lg:grid-cols-[1.2fr_1fr]">
        <div class="space-y-4">
          <h2 class="text-lg font-semibold text-zinc-900">Interactive map</h2>
          <StateMap.state_map states={@states} />
        </div>

        <div class="space-y-4">
          <h2 class="text-lg font-semibold text-zinc-900">Alphabetical checklist</h2>
          <div class="grid gap-3 sm:grid-cols-2">
            <div :for={state <- @states} class="rounded-2xl border border-zinc-200 p-4">
              <div class="flex items-start justify-between gap-3">
                <div>
                  <p class="font-semibold text-zinc-900"><%= state.name %></p>
                  <p class="text-xs uppercase tracking-[0.2em] text-zinc-500"><%= state.code %></p>
                </div>
                <span class={[
                  "rounded-full px-2 py-1 text-xs font-semibold",
                  state.seen && "bg-emerald-100 text-emerald-700",
                  !state.seen && "bg-zinc-100 text-zinc-600"
                ]}>
                  <%= if state.seen, do: "Seen", else: "Not seen" %>
                </span>
              </div>
              <div class="mt-4 flex gap-2">
                <button phx-click="toggle_state" phx-value-state={state.code} class="rounded-lg bg-zinc-900 px-3 py-2 text-sm font-semibold text-white hover:bg-zinc-700">
                  <%= if state.seen, do: "Uncheck", else: "Mark seen" %>
                </button>
                <button phx-click="show_trivia" phx-value-state={state.code} class="rounded-lg border border-zinc-200 px-3 py-2 text-sm font-semibold text-zinc-900 hover:bg-zinc-50">
                  Trivia
                </button>
              </div>
            </div>
          </div>
        </div>
      </section>

      <.modal :if={@selected_state} id="trivia-modal" show on_cancel={JS.push("close_trivia")}>
        <div class="space-y-4">
          <div>
            <p class="text-sm font-semibold uppercase tracking-[0.3em] text-zinc-500">State trivia</p>
            <h2 class="mt-2 text-2xl font-semibold text-zinc-900"><%= @selected_state.name %></h2>
          </div>
          <p class="text-base leading-7 text-zinc-700"><%= @selected_state.trivia %></p>
        </div>
      </.modal>
    </div>
    """
  end
end
