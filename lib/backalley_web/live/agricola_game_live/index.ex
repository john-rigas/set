defmodule BackalleyWeb.AgricolaGameLive.Index do
  use BackalleyWeb, :live_view

  alias Backalley.Agricola
  alias Backalley.Agricola.AgricolaGame

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :agricola_games, list_agricola_games())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Agricola game")
    |> assign(:agricola_game, Agricola.get_agricola_game!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Agricola game")
    |> assign(:agricola_game, %AgricolaGame{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Agricola games")
    |> assign(:agricola_game, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    agricola_game = Agricola.get_agricola_game!(id)
    {:ok, _} = Agricola.delete_agricola_game(agricola_game)

    {:noreply, assign(socket, :agricola_games, list_agricola_games())}
  end

  defp list_agricola_games do
    Agricola.list_agricola_games()
  end

end
