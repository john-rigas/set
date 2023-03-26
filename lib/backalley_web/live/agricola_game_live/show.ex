defmodule BackalleyWeb.AgricolaGameLive.Show do
  use BackalleyWeb, :live_view

  alias Backalley.Agricola

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:agricola_game, Agricola.get_agricola_game!(id))}
  end

  defp page_title(:show), do: "Show Agricola game"
  defp page_title(:edit), do: "Edit Agricola game"
end
