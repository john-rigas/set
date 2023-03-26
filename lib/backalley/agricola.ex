defmodule Backalley.Agricola do
  @moduledoc """
  The Agricola context.
  """

  import Ecto.Query, warn: false
  alias Backalley.Repo

  alias Backalley.Agricola.AgricolaGame

  @doc """
  Returns the list of agricola_games.

  ## Examples

      iex> list_agricola_games()
      [%AgricolaGame{}, ...]

  """
  def list_agricola_games do
    Repo.all(AgricolaGame)
  end

  @doc """
  Gets a single agricola_game.

  Raises `Ecto.NoResultsError` if the Agricola game does not exist.

  ## Examples

      iex> get_agricola_game!(123)
      %AgricolaGame{}

      iex> get_agricola_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_agricola_game!(id), do: Repo.get!(AgricolaGame, id)

  @doc """
  Creates a agricola_game.

  ## Examples

      iex> create_agricola_game(%{field: value})
      {:ok, %AgricolaGame{}}

      iex> create_agricola_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_agricola_game(attrs \\ %{}) do
    %AgricolaGame{}
    |> AgricolaGame.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a agricola_game.

  ## Examples

      iex> update_agricola_game(agricola_game, %{field: new_value})
      {:ok, %AgricolaGame{}}

      iex> update_agricola_game(agricola_game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_agricola_game(%AgricolaGame{} = agricola_game, attrs) do
    agricola_game
    |> AgricolaGame.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a agricola_game.

  ## Examples

      iex> delete_agricola_game(agricola_game)
      {:ok, %AgricolaGame{}}

      iex> delete_agricola_game(agricola_game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_agricola_game(%AgricolaGame{} = agricola_game) do
    Repo.delete(agricola_game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking agricola_game changes.

  ## Examples

      iex> change_agricola_game(agricola_game)
      %Ecto.Changeset{data: %AgricolaGame{}}

  """
  def change_agricola_game(%AgricolaGame{} = agricola_game, attrs \\ %{}) do
    AgricolaGame.changeset(agricola_game, attrs)
  end
end
