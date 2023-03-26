defmodule Backalley.AgricolaFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backalley.Agricola` context.
  """

  @doc """
  Generate a agricola_game.
  """
  def agricola_game_fixture(attrs \\ %{}) do
    {:ok, agricola_game} =
      attrs
      |> Enum.into(%{

      })
      |> Backalley.Agricola.create_agricola_game()

    agricola_game
  end
end
