defmodule Backalley.Repo.Migrations.GameTypes do
  use Ecto.Migration

  def change do
    create table(:game_types) do
      add :name, :string, null: false
      timestamps(default: fragment("current_timestamp"), updated_at: false)
    end

    create unique_index(:game_types, [:name])
  end
end
