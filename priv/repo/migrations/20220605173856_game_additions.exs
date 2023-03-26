defmodule Backalley.Repo.Migrations.GameAdditions do
  use Ecto.Migration

  def change do
    alter table(:set_games) do
      add :started_at, :naive_datetime
      add :ended_at, :naive_datetime
    end

    alter table(:set_players) do
      add :num_sets, :integer, default: 0
    end
  end
end
