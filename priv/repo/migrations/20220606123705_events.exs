defmodule Backalley.Repo.Migrations.Events do
  use Ecto.Migration

  def change do
    create table(:manual_entry_events) do
      add :set_player_id, references(:set_players, on_delete: :delete_all)
      add :num_sets, :integer
      timestamps(default: fragment("current_timestamp"), updated_at: false)
    end

  end
end
