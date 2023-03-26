defmodule Backalley.Repo.Migrations.NewSetTables do
  use Ecto.Migration

  def change do
    create table(:set_call_events) do
      add :set_player_id, references(:set_players, on_delete: :delete_all), null: false
      timestamps(default: fragment("current_timestamp"), updated_at: false)
    end

    create table(:set_cards) do
      add :number, :integer, null: false
      add :shape, :integer, null: false
      add :color, :integer, null: false
      add :pattern, :integer, null: false
    end

    create table(:set_call_cards) do
      add :set_call_event_id, references(:set_call_events, on_delete: :delete_all)
      add :set_card_id, references(:set_cards, on_delete: :delete_all)
    end

    create table(:deal_events) do
      add :set_game_id, references(:set_games, on_delete: :delete_all)
      add :set_card_id, references(:set_cards, on_delete: :delete_all)
      timestamps(default: fragment("current_timestamp"), updated_at: false)
    end

  end
end
