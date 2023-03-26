defmodule Backalley.Set.Events.Status do
  use Ecto.Schema
  alias Backalley.Set.Game

  @schema_prefix "set"
  schema "status" do
    belongs_to :game, Game
    field :status, Ecto.Enum, values: [created: 1, ready: 2, live: 3, complete: 4]
    field :inserted_at, :naive_datetime
  end

end
