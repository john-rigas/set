defmodule Backalley.Set.Events.Deal do
  use Ecto.Schema
  alias Backalley.Set.{Game, Card}

  @schema_prefix "set"
  schema "deals" do
    belongs_to :game, Game
    belongs_to :card, Card
    field :inserted_at, :naive_datetime
  end

end
