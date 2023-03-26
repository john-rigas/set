defmodule Backalley.Repo.Migrations.SetGames do
  use Ecto.Migration

  def change do
    create table(:set_games) do
      add :name, :string
      add :manual_entry, :boolean, default: false
      timestamps(default: fragment("current_timestamp"))
    end

    create unique_index(:set_games, [:name])
  end
end
