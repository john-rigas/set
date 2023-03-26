defmodule Backalley.Set.Events.Manual do
  use Ecto.Schema
  alias Backalley.Set.Events.Player

  @schema_prefix "set"
  schema "manual" do
    field :num_sets, :integer
    belongs_to :player, Player
    field :inserted_at, :naive_datetime
  end

end
