defmodule Backalley.Agricola.AgricolaGame do
  use Ecto.Schema
  import Ecto.Changeset

  schema "agricola_games" do


    timestamps()
  end

  @doc false
  def changeset(agricola_game, attrs) do
    agricola_game
    |> cast(attrs, [])
    |> validate_required([])
  end
end
