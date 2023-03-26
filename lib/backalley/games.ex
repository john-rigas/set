defmodule Backalley.Games do
  alias Backalley.Repo
  alias Backalley.Games.{GameType}

  def get_game_types() do
    Repo.all(GameType)
  end

end
