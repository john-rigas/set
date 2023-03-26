defmodule Backalley.Repo.Migrations.CreatedBy do
  use Ecto.Migration

  def change do
    alter table(:set_games) do
      add :created_by, references(:users)
    end
  end
end
