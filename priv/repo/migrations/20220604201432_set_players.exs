defmodule Backalley.Repo.Migrations.SetPlayers do
  use Ecto.Migration

  def change do
    create table(:set_players) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :set_game_id, references(:set_games, on_delete: :delete_all), null: false
      timestamps(default: fragment("current_timestamp"))
    end

    create unique_index(:set_players, [:user_id, :set_game_id])
  end
end
