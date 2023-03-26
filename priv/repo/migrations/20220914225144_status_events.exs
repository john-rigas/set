defmodule Backalley.Repo.Migrations.StatusEvents do
  use Ecto.Migration

  def change do
    create table(:status_events) do
      add :set_game_id, references(:set_games, on_delete: :delete_all)
      add :status, :string
      timestamps(default: fragment("current_timestamp"), updated_at: false)
    end
  end
end
