defmodule FindStatePlatesWeb.TripLive.Index do
  use FindStatePlatesWeb, :live_view

  alias FindStatePlates.Trips
  alias FindStatePlates.Trips.Trip

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Trips")
     |> assign(:trips, Trips.list_trips(socket.assigns.current_user))
     |> assign_form(Trips.change_trip(%Trip{}))}
  end

  @impl true
  def handle_event("validate", %{"trip" => trip_params}, socket) do
    changeset =
      %Trip{}
      |> Trips.change_trip(trip_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"trip" => trip_params}, socket) do
    case Trips.create_trip(socket.assigns.current_user, trip_params) do
      {:ok, _trip} ->
        {:noreply,
         socket
         |> put_flash(:info, "Trip created.")
         |> assign(:trips, Trips.list_trips(socket.assigns.current_user))
         |> assign_form(Trips.change_trip(%Trip{}))}

      {:error, changeset} ->
        {:noreply, assign_form(socket, Map.put(changeset, :action, :insert))}
    end
  end

  defp assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-10">
      <section class="space-y-3">
        <h1 class="text-3xl font-semibold tracking-tight text-zinc-900">Your trips</h1>
        <p class="text-sm leading-6 text-zinc-600">Create a trip, then track every state plate you spot from the road.</p>
      </section>

      <section class="rounded-2xl border border-zinc-200 p-6">
        <h2 class="text-lg font-semibold text-zinc-900">New trip</h2>
        <.simple_form for={@form} phx-change="validate" phx-submit="save">
          <.input field={@form[:name]} type="text" label="Trip name" placeholder="Summer road trip" required />
          <.input field={@form[:started_on]} type="date" label="Start date" />
          <.input field={@form[:notes]} type="textarea" label="Notes" />
          <:actions>
            <.button>Create trip</.button>
          </:actions>
        </.simple_form>
      </section>

      <section class="grid gap-4 md:grid-cols-2">
        <article :for={trip <- @trips} class="rounded-2xl border border-zinc-200 p-5">
          <div class="flex items-start justify-between gap-4">
            <div>
              <h2 class="text-xl font-semibold text-zinc-900"><%= trip.name %></h2>
              <p :if={trip.started_on} class="mt-1 text-sm text-zinc-500">Started <%= trip.started_on %></p>
              <p class="mt-2 text-sm text-zinc-600"><%= Enum.count(trip.checked_states) %> states seen</p>
            </div>
            <.link navigate={~p"/trips/#{trip.id}"} class="text-sm font-semibold text-zinc-900 underline underline-offset-4">
              Open trip
            </.link>
          </div>
          <p :if={trip.notes} class="mt-3 text-sm leading-6 text-zinc-600"><%= trip.notes %></p>
        </article>
      </section>
    </div>
    """
  end
end
