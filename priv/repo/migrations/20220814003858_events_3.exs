defmodule Backalley.Repo.Migrations.Events3 do
  use Ecto.Migration

  def change do
    alter table(:set_players) do
      remove :num_sets
    end
  end
end
