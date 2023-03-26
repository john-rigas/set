defmodule Backalley.Set.Fact.Game do
  use Ecto.Schema

  # alias Set.Game
  # alias Set.Events.Player

  @schema_prefix "set"
  schema "game_fact" do
    field :score, :integer
    # embeds_one :game, Game
    # embeds_one :player, Player
    field :game_id, :integer
    field :player_id, :integer
  end


end
