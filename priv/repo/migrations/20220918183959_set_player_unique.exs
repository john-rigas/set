defmodule Backalley.Repo.Migrations.SetPlayerUnique do
  use Ecto.Migration

  def change do
    create unique_index(:players, [:user_id, :game_id], prefix: :set)
  end
end
