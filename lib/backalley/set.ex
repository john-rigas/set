defmodule Backalley.Set do
  alias Backalley.Repo
  alias Backalley.Set
  alias Backalley.Set.State
  alias Backalley.Set.Events.Event
  alias Backalley.Set.Events
  alias Backalley.Set.Fact
  import Ecto.Query

  def list_set_games() do
    Repo.all from g in Set.Game, order_by: [desc: g.inserted_at]
  end

  def list_game_facts() do
    query = from g in Fact.Game,
      join: p in Events.Player, on: p.id == g.player_id,
      join: u in Backalley.Accounts.User, on: u.id == p.user_id,
      select: {g.game_id, u.name, g.score}

    Repo.all(query) |> Enum.group_by(fn {id, _, _} -> id end, fn {_, name, score} -> %{name: name, score: score} end)
  end

  def create_set_game(name, creator) do
    %Set.Game{name: name}
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:creator, creator)
    |> Repo.insert!()
  end

  def add_player(game_state, user) do
    %Set.Events.Player{}
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:game, game_state.game)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert!()
    |> Event.process(game_state)
  end


  def add_manual_entry(game_state, num_sets, player) do
    %Set.Events.Manual{num_sets: num_sets}
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:player, player)
    |> Repo.insert!()
    |> Event.process(game_state)
  end

  def update_game_status(game_state, status) do
    %Set.Events.Status{status: status}
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:game, game_state.game)
    |> Repo.insert!()
    |> Event.process(game_state)
  end

  def call_set(game_state, set, player) do
    %Set.Events.Call{}
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:player, player.player)
    |> Ecto.Changeset.put_assoc(:cards, set)
    |> Repo.insert!()
    |> Event.process(game_state)
    |> deal()
  end

  def initialize_game_state(game = %Set.Game{}) do
     %State.Game{game: game, status: :created, board: %{}} |> initialize_deck()
  end

  def initialize_game_by_id(id) do
    Repo.get!(Set.Game, id) |> Repo.preload([:creator], prefix: :public) |> initialize_game_state() |> replay_events()
  end

  defp replay_events(game_state) do
    statuses = Repo.all(from s in Events.Status, where: s.game_id == ^game_state.game.id, select: s)
    players = Repo.all(from p in Events.Player, where: p.game_id == ^game_state.game.id, select: p) |> Repo.preload([:user], prefix: :public)
    deals = Repo.all(from d in Events.Deal, where: d.game_id == ^game_state.game.id, select: d, preload: [:card])
    player_ids = Enum.map(players, fn p -> p.id end)
    calls = Repo.all(from c in Events.Call, where: c.player_id in ^player_ids, select: c, preload: [:cards, player: [:user]])
    manuals = Repo.all(from m in Events.Manual, where: m.player_id in ^player_ids, select: m, preload: [player: [:user]])
    statuses ++ players ++ deals ++ calls ++ manuals
    |> Enum.sort(&(&1.inserted_at <= &2.inserted_at))
    |> Enum.reduce(game_state, fn event, game_state -> Event.process(event, game_state) end)
  end

  def initialize_deck(game_state = %State.Game{}) do
    cards = case Repo.all(Set.Card) do
      [] -> initialize_cards() |> Enum.shuffle()
      card_results -> Enum.shuffle(card_results)
    end
    put_in(game_state.deck, cards)
  end

  defp deal_card(game_state, card) do
    %Set.Events.Deal{}
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:game, game_state.game)
    |> Ecto.Changeset.put_assoc(:card, card)
    |> Repo.insert!()
    |> Event.process(game_state)
  end

  def deal(game_state = %State.Game{}) do
    cond do
      length(game_state.deck) == 0 and !State.Game.has_set(game_state) -> update_game_status(game_state, :complete)
      length(game_state.deck) == 0 -> game_state
      length(Map.keys(game_state.board)) < 12 or rem(length(Map.keys(game_state.board)), 3) != 0 or !State.Game.has_set(game_state) -> deal_card(game_state, Enum.random(game_state.deck)) |> deal()
      true -> game_state
    end
  end

  def initialize_cards() do
    cards = Enum.flat_map(Ecto.Enum.mappings(Set.Card, :number), fn {number, _} ->
      Enum.flat_map(Ecto.Enum.mappings(Set.Card, :shape), fn {shape, _} ->
        Enum.flat_map(Ecto.Enum.mappings(Set.Card, :color), fn {color, _} ->
          Enum.map(Ecto.Enum.mappings(Set.Card, :pattern), fn {pattern, _} ->
            %{number: number, shape: shape, color: color, pattern: pattern}
          end)
        end)
      end)
    end)

    Repo.insert_all(Set.Card, cards, returning: true)
  end


  def save_to_game_fact(game_state) do
    insert_data = Enum.map(game_state.players, fn player_state -> %{player_id: player_state.player.id, game_id: game_state.game.id, score: player_state.num_sets - max(0, player_state.fouls - 1)} end)

    Repo.insert_all(
      Fact.Game,
      insert_data,
      on_conflict: :replace_all,
      conflict_target: [:player_id, :game_id]
    )

  end

  def update_game_fact(id) do
    id |> initialize_game_by_id() |> save_to_game_fact()
  end

  def update_all_game_facts() do
    list_set_games()
    |> Enum.each(fn game -> update_game_fact(game.id) end)
  end

  def get_standings() do
    ranking_query =
      from g in Fact.Game,
      select: %{game_id: g.game_id, score: g.score, player_id: g.player_id, rank: over(rank(), :game_partition)},
      windows: [game_partition: [partition_by: :game_id, order_by: [desc: :score]]]

    query =
      from p in Events.Player,
      join: u in Backalley.Accounts.User, on: u.id == p.user_id,
      left_join: g in subquery(ranking_query), on: p.id == g.player_id and g.rank == 1,
      group_by: [u.id, u.name],
      select: {u.name, count(g.game_id)}

    Repo.all(query)
  end

end
