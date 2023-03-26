defmodule Backalley.Set.State.Game do
  use Ecto.Schema
  alias Backalley.Set.{Game, Card}
  alias Backalley.Set.State
  alias Backalley.Helpers

  schema "state:game" do
    belongs_to :game, Game
    field :started_at, :naive_datetime
    field :ended_at, :naive_datetime
    field :status, Ecto.Enum, values: [created: 1, ready: 2, live: 3, complete: 4]
    field :current_message, :string
    field :board, :map
    embeds_many :deck, Card
    embeds_many :last_set_call, Card
    embeds_many :players, State.Player
  end

  def has_set(game_state) do
    Enum.any?(Helpers.combination(3, Map.values(game_state.board)), fn x -> Card.is_set(x) end)
  end

end
