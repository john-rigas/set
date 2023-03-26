defmodule Backalley.Set.Events.Player do
  use Ecto.Schema
  alias Backalley.Set.Game
  alias Backalley.Accounts.User

  @schema_prefix "set"
  schema "players" do
    belongs_to :game, Game
    belongs_to :user, User
    field :inserted_at, :naive_datetime
  end


end
