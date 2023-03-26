defmodule Backalley.AgricolaTest do
  use Backalley.DataCase

  alias Backalley.Agricola

  describe "agricola_games" do
    alias Backalley.Agricola.AgricolaGame

    import Backalley.AgricolaFixtures

    @invalid_attrs %{}

    test "list_agricola_games/0 returns all agricola_games" do
      agricola_game = agricola_game_fixture()
      assert Agricola.list_agricola_games() == [agricola_game]
    end

    test "get_agricola_game!/1 returns the agricola_game with given id" do
      agricola_game = agricola_game_fixture()
      assert Agricola.get_agricola_game!(agricola_game.id) == agricola_game
    end

    test "create_agricola_game/1 with valid data creates a agricola_game" do
      valid_attrs = %{}

      assert {:ok, %AgricolaGame{} = agricola_game} = Agricola.create_agricola_game(valid_attrs)
    end

    test "create_agricola_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Agricola.create_agricola_game(@invalid_attrs)
    end

    test "update_agricola_game/2 with valid data updates the agricola_game" do
      agricola_game = agricola_game_fixture()
      update_attrs = %{}

      assert {:ok, %AgricolaGame{} = agricola_game} = Agricola.update_agricola_game(agricola_game, update_attrs)
    end

    test "update_agricola_game/2 with invalid data returns error changeset" do
      agricola_game = agricola_game_fixture()
      assert {:error, %Ecto.Changeset{}} = Agricola.update_agricola_game(agricola_game, @invalid_attrs)
      assert agricola_game == Agricola.get_agricola_game!(agricola_game.id)
    end

    test "delete_agricola_game/1 deletes the agricola_game" do
      agricola_game = agricola_game_fixture()
      assert {:ok, %AgricolaGame{}} = Agricola.delete_agricola_game(agricola_game)
      assert_raise Ecto.NoResultsError, fn -> Agricola.get_agricola_game!(agricola_game.id) end
    end

    test "change_agricola_game/1 returns a agricola_game changeset" do
      agricola_game = agricola_game_fixture()
      assert %Ecto.Changeset{} = Agricola.change_agricola_game(agricola_game)
    end
  end
end
