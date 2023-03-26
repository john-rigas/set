defmodule Backalley.Repo.Migrations.NewSchema do
  use Ecto.Migration

  def change do
    create table(:games, prefix: "set") do
      add :name, :string
      add :created_by, references(:users, prefix: :public)
      timestamps(default: fragment("current_timestamp"))
    end

    create table(:cards, prefix: "set") do
      add :number, :integer, null: false
      add :shape, :integer, null: false
      add :color, :integer, null: false
      add :pattern, :integer, null: false
    end

    create table(:status, prefix: "set") do
      add :game_id, references(:games, on_delete: :delete_all)
      add :status, :integer
      timestamps(default: fragment("current_timestamp"), updated_at: false)
    end

    create table(:deals, prefix: "set") do
      add :game_id, references(:games, on_delete: :delete_all)
      add :card_id, references(:cards, on_delete: :delete_all)
      timestamps(default: fragment("current_timestamp"), updated_at: false)
    end

    create table(:players, prefix: "set") do
      add :user_id, references(:users, prefix: :public)
      add :game_id, references(:games)
      timestamps(default: fragment("current_timestamp"), updated_at: false)
    end

    create table(:manual, prefix: "set") do
      add :num_sets, :integer
      add :player_id, references(:players)
      timestamps(default: fragment("current_timestamp"), updated_at: false)
    end

    create table(:calls, prefix: "set") do
      add :player_id, references(:players, on_delete: :delete_all)
      timestamps(default: fragment("current_timestamp"), updated_at: false)
    end

    create table(:call_cards, prefix: "set") do
      add :call_id, references(:calls, on_delete: :delete_all)
      add :card_id, references(:cards, on_delete: :delete_all)
    end
  end
end
