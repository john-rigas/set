defmodule BackalleyWeb.AgricolaGameLiveTest do
  use BackalleyWeb.ConnCase

  import Phoenix.LiveViewTest
  import Backalley.AgricolaFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_agricola_game(_) do
    agricola_game = agricola_game_fixture()
    %{agricola_game: agricola_game}
  end

  describe "Index" do
    setup [:create_agricola_game]

    test "lists all agricola_games", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.agricola_game_index_path(conn, :index))

      assert html =~ "Listing Agricola games"
    end

    test "saves new agricola_game", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.agricola_game_index_path(conn, :index))

      assert index_live |> element("a", "New Agricola game") |> render_click() =~
               "New Agricola game"

      assert_patch(index_live, Routes.agricola_game_index_path(conn, :new))

      assert index_live
             |> form("#agricola_game-form", agricola_game: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#agricola_game-form", agricola_game: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.agricola_game_index_path(conn, :index))

      assert html =~ "Agricola game created successfully"
    end

    test "updates agricola_game in listing", %{conn: conn, agricola_game: agricola_game} do
      {:ok, index_live, _html} = live(conn, Routes.agricola_game_index_path(conn, :index))

      assert index_live |> element("#agricola_game-#{agricola_game.id} a", "Edit") |> render_click() =~
               "Edit Agricola game"

      assert_patch(index_live, Routes.agricola_game_index_path(conn, :edit, agricola_game))

      assert index_live
             |> form("#agricola_game-form", agricola_game: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#agricola_game-form", agricola_game: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.agricola_game_index_path(conn, :index))

      assert html =~ "Agricola game updated successfully"
    end

    test "deletes agricola_game in listing", %{conn: conn, agricola_game: agricola_game} do
      {:ok, index_live, _html} = live(conn, Routes.agricola_game_index_path(conn, :index))

      assert index_live |> element("#agricola_game-#{agricola_game.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#agricola_game-#{agricola_game.id}")
    end
  end

  describe "Show" do
    setup [:create_agricola_game]

    test "displays agricola_game", %{conn: conn, agricola_game: agricola_game} do
      {:ok, _show_live, html} = live(conn, Routes.agricola_game_show_path(conn, :show, agricola_game))

      assert html =~ "Show Agricola game"
    end

    test "updates agricola_game within modal", %{conn: conn, agricola_game: agricola_game} do
      {:ok, show_live, _html} = live(conn, Routes.agricola_game_show_path(conn, :show, agricola_game))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Agricola game"

      assert_patch(show_live, Routes.agricola_game_show_path(conn, :edit, agricola_game))

      assert show_live
             |> form("#agricola_game-form", agricola_game: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#agricola_game-form", agricola_game: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.agricola_game_show_path(conn, :show, agricola_game))

      assert html =~ "Agricola game updated successfully"
    end
  end
end
