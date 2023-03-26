defmodule BackalleyWeb.GameController do
  use BackalleyWeb, :controller

  alias Backalley.Games

  def index(conn, _params) do
    assign(conn, :game_types, Games.get_game_types()) |> render("index.html")
  end

end
