defmodule ManualEntryComponent do
  use BackalleyWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>

        <.form let={f} for={:manual_entry} phx-target={@myself} phx-submit="manual-entry" phx-val-user-id={assigns.player.player.user.id} >
            <span><%= assigns.player.player.user.name %></span>
            <span>Current score: <%= assigns.player.num_sets - max(assigns.player.fouls - 1, 0)  %></span>
            <%= number_input f, :num_sets %>
            <%= submit "Add sets" %>
        </.form>

    </div>
    """
  end

  def handle_event("manual-entry", %{"manual_entry" => %{"num_sets" => num_sets}}, socket) do
    GenServer.cast({:global, "set:#{socket.assigns.game_id}"}, {:manual_entry, %{num_sets: String.to_integer(num_sets), player: socket.assigns.player.player}})
    {:noreply, socket}
  end

end
