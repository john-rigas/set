defmodule Backalley.Set.State.Player do
  use Ecto.Schema
  alias Backalley.Set.Events

  schema "state:player" do
    embeds_one :player, Events.Player
    field :num_sets, :integer
    field :fouls, :integer
  end

end
