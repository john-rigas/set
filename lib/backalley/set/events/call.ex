defmodule Backalley.Set.Events.Call do
  use Ecto.Schema
  alias Backalley.Set.Card
  alias Backalley.Set.Events.Player

  @schema_prefix "set"
  schema "calls" do
    belongs_to :player, Player
    many_to_many :cards, Card, join_through: "call_cards"
    field :inserted_at, :naive_datetime
  end

end
