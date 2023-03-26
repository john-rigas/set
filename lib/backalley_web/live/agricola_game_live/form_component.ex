defmodule BackalleyWeb.AgricolaGameLive.FormComponent do
  use BackalleyWeb, :live_component

  alias Backalley.Agricola

  @impl true
  def update(%{agricola_game: agricola_game} = assigns, socket) do
    changeset = Agricola.change_agricola_game(agricola_game)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"agricola_game" => agricola_game_params}, socket) do
    changeset =
      socket.assigns.agricola_game
      |> Agricola.change_agricola_game(agricola_game_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"agricola_game" => agricola_game_params}, socket) do
    save_agricola_game(socket, socket.assigns.action, agricola_game_params)
  end

  defp save_agricola_game(socket, :edit, agricola_game_params) do
    case Agricola.update_agricola_game(socket.assigns.agricola_game, agricola_game_params) do
      {:ok, _agricola_game} ->
        {:noreply,
         socket
         |> put_flash(:info, "Agricola game updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_agricola_game(socket, :new, agricola_game_params) do
    case Agricola.create_agricola_game(agricola_game_params) do
      {:ok, _agricola_game} ->
        {:noreply,
         socket
         |> put_flash(:info, "Agricola game created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
