defmodule Backalley.Repo.Migrations.AddGameFactTables do
  use Ecto.Migration

  def change do
    create table(:game_fact, prefix: "set") do
      add :game_id, references(:games, on_delete: :delete_all)
      add :player_id, references(:players, on_delete: :delete_all)
      add :score, :integer
      timestamps(default: fragment("current_timestamp"))
    end

    create index("game_fact", [:game_id, :player_id], unique: true, prefix: "set")

  end
end
