defmodule Backalley.Set.ManualEntryEvent do
  use Ecto.Schema
  alias Backalley.Set.SetPlayer

  @schema_prefix "public"
  schema "manual_entry_events" do
    field :num_sets, :integer
    belongs_to :set_player, SetPlayer
  end


end
