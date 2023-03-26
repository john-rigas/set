defmodule BackalleyWeb.SetLive.Game do
  use BackalleyWeb, :live_view
  use BackalleyWeb.LiveViewNativeHelpers, template: "game"

  alias Backalley.Set
  alias Backalley.Accounts

  # on_mount {Backalley.LiveAuth, {false, :cont, {:redirect, NarwinChatWeb.LobbyLive}}}

  @impl true
  def render(assigns) do
    render_native(assigns)
  end


  @impl true
  def mount(_params, session, socket) do
    {:ok,
    socket
    |> assign(:current_user, Accounts.get_user_by_session_token(session["user_token"]))}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    unless GenServer.whereis({:global, "set:#{id}"}) do
      game_state = Set.initialize_game_by_id(id)
      DynamicSupervisor.start_child(Backalley.DynamicSupervisor, {Backalley.SetServer, game_state})
    end
    game_state = GenServer.call({:global, "set:#{id}"}, :get)
    topic = "set:#{game_state.game.id}"
    BackalleyWeb.Endpoint.subscribe(topic)

    {:noreply,
     socket
     |> assign(:game, game_state)
     |> assign(:selected_cards, [])
     |> assign(:manual_entry_open, false)
     |> assign(:board_order, Enum.to_list(1..81))
     |> assign(:all_users, get_all_users_if_creator(game_state, socket.assigns.current_user))}
  end

  defp get_all_users_if_creator(game_state, user) do
    existing_user_ids = Enum.map(game_state.players, fn x -> x.player.user.id end)
    cond do
      game_state.game.creator.id == user.id -> Enum.filter(Accounts.list_users(), fn x -> x.id not in existing_user_ids end)
      true -> nil
    end
  end

  @impl true
  def handle_event("add-player", %{"id" => id}, socket) do
    GenServer.cast({:global, "set:#{socket.assigns.game.game.id}"}, {:add_player, Accounts.get_user!(id)})
    {:noreply, socket}
  end

  @impl true
  def handle_event("enter-scores", _params, socket) do
    {:noreply, socket |> assign(:manual_entry_open, true)}
  end

  @impl true
  def handle_event("start-game", _params, socket) do
    GenServer.cast({:global, "set:#{socket.assigns.game.game.id}"}, {:status, :live})
    {:noreply, socket}
  end

  @impl true
  def handle_event("select-card", %{"id" => id}, socket) do
    {:noreply,
      socket
      |> assign_new(:selected_cards, fn -> [] end)
      |> select_card(id)}
  end

  @impl true
  def handle_event("shuffle", _params, socket) do
    {:noreply, socket |> assign(:board_order, Enum.shuffle(1..81))}
  end

  defp select_card(socket, id) do
    id = String.to_integer(id)
    card = Enum.find(get_board_as_list(socket.assigns.game.board, socket.assigns.board_order), fn card -> card.id == id end)
    selected_cards = cond do
      Enum.any?(socket.assigns.selected_cards, fn card -> card.id == id end) -> Enum.filter(socket.assigns.selected_cards, fn card -> card.id != id end)
      true -> [card | socket.assigns.selected_cards]
    end
    cond do
      length(selected_cards) < 3 -> assign(socket, :selected_cards, selected_cards)
      true -> call_set(socket, selected_cards)
    end
  end

  defp call_set(socket, set) do
    player = Enum.find(socket.assigns.game.players, fn player -> player.player.user.id == socket.assigns.current_user.id end)
    GenServer.cast({:global, "set:#{socket.assigns.game.game.id}"}, {:call_set, %{set: set, player: player}})
    assign(socket, :selected_cards, [])
  end

  @impl true
  def handle_info({"game-update", game}, socket) when socket.assigns.game.game.id == game.game.id do
    {:noreply, socket |> assign(:game, game) |> assign(:all_users, get_all_users_if_creator(game, socket.assigns.current_user))}
  end

  def scoreboard(assigns) do
    ~H"""
      <div class="flex gap-6">
        <%= for player <- assigns.players do %>
          <div class="flex flex-col items-center">
            <span><%= player.player.user.name %></span>
            <span><%= player.num_sets - max(0, player.fouls - 1) %></span>
          </div>
        <% end %>
      </div>
    """
  end

  def card(assigns) do

    number = case assigns.number do
      :three -> 3
      :two -> 2
      :one -> 1
    end

    border = case assigns.selected do
      true -> "border-blue-200 border-4 rounded-xl"
      false -> "border-black border-4 rounded-xl"
    end

    ~H"""
    <div class={"#{border}"}>
      <img src={Routes.static_path(BackalleyWeb.Endpoint, "/images/set_#{assigns.color}_#{assigns.shape}_#{assigns.pattern}_#{number}.png")} alt={"#{assigns.color}_#{assigns.shape}_#{assigns.pattern}_#{number}"} />
    </div>
    """

  end

  def is_selected(selected_cards, card) do
    !!Enum.find(selected_cards, fn c -> c.id == card.id end)
  end

  def get_board_as_list(board, board_order) do
    Enum.filter(board_order, fn x -> x in Map.keys(board) end) |> Enum.map(fn x -> board[x] end)
  end

  def user_in_game(user, game_state) do
    user.id in Enum.map(game_state.players, fn player_state -> player_state.player.user.id end)
  end

end
