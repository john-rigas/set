defmodule Backalley.Repo.Migrations.AddPublicGame do
  use Ecto.Migration

  def change do
    alter table(:games, prefix: "set") do
      add :public, :boolean, default: true
    end
  end
end
