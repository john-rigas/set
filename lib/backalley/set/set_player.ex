defmodule Backalley.Set.SetPlayer do
  use Ecto.Schema

  @schema_prefix "public"
  schema "set_players" do
    field :num_sets, :integer
  end


end
