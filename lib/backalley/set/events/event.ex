defprotocol EventAction do
  def process(event, game)
  def rollback(event, game)
end

defmodule Backalley.Set.Events.Event do
 def process(event, game), do: EventAction.process(event, game)
 def rollback(event, game), do: EventAction.rollback(event, game)
end

defimpl EventAction, for: Backalley.Set.Events.Deal do

  def process(%{card: card}, game_state) do
    deck = Enum.filter(game_state.deck, fn x -> x.id != card.id end)
    game_state = put_in(game_state.deck, deck)
    idx = Enum.find(1..81, fn x -> !Map.get(game_state.board, x) end)
    put_in(game_state.board, Map.put(game_state.board, idx, card))
  end

  def rollback(%{card: card}, game) do

  end

end

defimpl EventAction, for: Backalley.Set.Events.Call do

  alias Backalley.Set.Card

  def process(%{cards: cards, player: player}, game_state) do
    player_state = Enum.find(game_state.players, fn p -> p.player.id == player.id end)
    valid_set = Card.is_set(cards)
    {num_sets, board, fouls, message} = cond do
      valid_set -> {player_state.num_sets + 1, Map.drop(game_state.board, Enum.filter(Map.keys(game_state.board), fn idx -> Enum.any?(cards, fn c -> c.id == game_state.board[idx].id end) end)), player_state.fouls, "#{player.user.name} scored"}
      true -> {player_state.num_sets, game_state.board, player_state.fouls + 1, "#{player.user.name} fouled"}
    end
    game_state = put_in(game_state.board, board)
    player_state = put_in(player_state.num_sets, num_sets)
    player_state = put_in(player_state.fouls, fouls)
    players = [player_state | Enum.filter(game_state.players, fn p -> p.player.id != player_state.player.id end)]
    game_state = put_in(game_state.players, players)
    game_state = put_in(game_state.current_message, message)
    game_state = put_in(game_state.last_set_call, cards)
  end

  def rollback(%{cards: cards}, game) do

  end

end

defimpl EventAction, for: Backalley.Set.Events.Manual do

  def process(%{num_sets: num_sets, player: player}, game_state) do
    player_state = Enum.find(game_state.players, fn p -> p.player.id == player.id end)
    player_state = put_in(player_state.num_sets, player_state.num_sets + num_sets)
    players = [player_state | Enum.filter(game_state.players, fn p -> p.player.id != player_state.player.id end)]
    put_in(game_state.players, players)
  end

  def rollback(%{num_sets: num_sets}, game_state) do

  end

end

defimpl EventAction, for: Backalley.Set.Events.Player do
  alias Backalley.Set.State.Player

  def process(player, game) do
    put_in(game.players, [%Player{player: player, num_sets: 0, fouls: 0} | game.players])
  end

  def rollback(player, game) do

  end

end

defimpl EventAction, for: Backalley.Set.Events.Status do

  def process(%{status: status}, game_state) do
    game_state = put_in(game_state.status, status)
    case status do
      :live -> put_in(game_state.started_at, NaiveDateTime.utc_now())
      :complete ->
        game_state = put_in(game_state.ended_at, NaiveDateTime.utc_now())
        put_in(game_state.current_message, "Game over")
      _ -> game_state
    end
  end

  def rollback(%{status: status}, game) do

  end

end
