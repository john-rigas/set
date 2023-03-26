defmodule Backalley.Repo.Migrations.Events2 do
  use Ecto.Migration
  alias Backalley.Repo
  alias Backalley.Set.SetPlayer
  alias Backalley.Set.ManualEntryEvent
  import Ecto.Query

  def change do


    query =
      from sp in SetPlayer,
        select: %{set_player_id: sp.id, num_sets: sp.num_sets}

    Repo.insert_all(ManualEntryEvent, query)


  end
end
