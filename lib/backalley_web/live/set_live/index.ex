defmodule BackalleyWeb.SetLive.Index do
  use BackalleyWeb, :live_view

  alias Backalley.Set
  alias Backalley.Accounts

  @impl true
  def mount(_params, session, socket) do
    {:ok,
    assign(socket, :games, list_set_games())
    |> assign(:game_map, list_set_game_facts())
    |> assign(:standings, get_standings())
    |> assign(:current_user, Accounts.get_user_by_session_token(session["user_token"]))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new_game, _params) do
    socket
    |> assign(:page_title, "Set")
    # |> assign(:game, %Set.Game{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Set")
    |> assign(:set_game, nil)
  end

  @impl true
  def handle_event("create-game", _, socket) do
    game_state = Set.create_set_game(nil, socket.assigns.current_user) |> Set.initialize_game_state()
    DynamicSupervisor.start_child(Backalley.DynamicSupervisor, {Backalley.SetServer, game_state})
    GenServer.cast({:global, "set:#{game_state.game.id}"}, {:add_player, socket.assigns.current_user})
    {:noreply,  push_redirect(socket, to: "/set/#{game_state.game.id}")}
  end


  @impl true
  def handle_event("refresh", _, socket) do
    Set.update_all_game_facts()
    {:noreply,
    socket
    |> assign(:game_map, list_set_game_facts())
    |> assign(:games, list_set_games())
    |> assign(:standings, get_standings())}
  end

  defp list_set_games do
    Set.list_set_games()
  end

  defp list_set_game_facts do
    Set.list_game_facts()
  end

  defp get_standings() do
    Set.get_standings()
  end

end
