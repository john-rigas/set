defmodule Backalley.Repo.Migrations.CreateAgricolaGames do
  use Ecto.Migration

  def change do
    create table(:agricola_games) do

      timestamps(default: fragment("current_timestamp"))
    end
  end
end
