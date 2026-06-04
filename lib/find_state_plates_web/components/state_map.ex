defmodule FindStatePlatesWeb.StateMap do
  use Phoenix.Component

  attr :states, :list, required: true

  def state_map(assigns) do
    ~H"""
    <svg viewBox="0 0 920 460" role="img" aria-label="Interactive US state tile map" class="w-full rounded-2xl border border-zinc-200 bg-zinc-50 p-4">
      <g :for={state <- @states}>
        <rect
          x={state.col * 54 + 20}
          y={state.row * 46 + 20}
          width="44"
          height="36"
          rx="8"
          class={[
            "cursor-pointer transition hover:stroke-zinc-700",
            state.seen && "fill-emerald-500 stroke-emerald-700",
            !state.seen && "fill-white stroke-zinc-300"
          ]}
          phx-click="toggle_state"
          phx-value-state={state.code}
        />
        <text
          x={state.col * 54 + 42}
          y={state.row * 46 + 43}
          text-anchor="middle"
          class={[
            "pointer-events-none text-[11px] font-semibold",
            state.seen && "fill-white",
            !state.seen && "fill-zinc-700"
          ]}
        >
          <%= state.code %>
        </text>
      </g>
    </svg>
    """
  end
end
