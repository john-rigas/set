defmodule Backalley.SetServer do
  use GenServer
  alias Backalley.Set.State
  alias Backalley.Set
  alias Backalley.Accounts.User


  def start_link(game_state) when is_struct(game_state, State.Game) do
    GenServer.start_link(__MODULE__, game_state, name: {:global, "set:#{game_state.game.id}"})
  end

  @impl true
  def init(game_state) do
    {:ok, game_state}
  end

  @impl true
  def handle_cast({:add_player, user = %User{}}, game_state) do
    {:noreply, Set.add_player(game_state, user) |> broadcast_game()}
  end

  @impl true
  def handle_cast({:manual_entry, %{num_sets: num_sets, player: player}}, game_state) do
    {:noreply, Set.add_manual_entry(game_state, num_sets, player) |> broadcast_game()}
  end

  @impl true
  def handle_cast({:status, status}, game_state) do
    {:noreply,
      Set.update_game_status(game_state, status)
      |> Set.initialize_deck()
      |> Set.deal()
      |> broadcast_game()}
  end

  @impl true
  def handle_cast({:call_set, %{set: set, player: player}}, game_state) do
    {:noreply,
      Set.call_set(game_state, set, player)
      |> broadcast_game()}
  end

  @impl true
  def handle_cast({:deal, _}, game_state) do
    {:noreply, Set.deal(game_state) |> broadcast_game()}
  end

  defp broadcast_game(game_state) do
    Phoenix.PubSub.broadcast(Backalley.PubSub, "set:#{game_state.game.id}", {"game-update", game_state})
    game_state
  end

  @impl true
  def handle_call(:get, _from, game_state), do: {:reply, game_state, game_state}
end
