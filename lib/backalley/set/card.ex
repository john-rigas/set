defmodule Backalley.Set.Card do
  use Ecto.Schema

  @schema_prefix "set"
  schema "cards" do
    field :number, Ecto.Enum, values: [one: 1, two: 2, three: 3]
    field :shape, Ecto.Enum, values: [diamond: 1, oval: 2, squiggle: 3]
    field :color, Ecto.Enum, values: [red: 1, purple: 2, green: 3]
    field :pattern, Ecto.Enum, values: [solid: 1, striped: 2, empty: 3]

  end

  def is_set(cards) do
    patterns = Enum.map(cards, fn card -> card.pattern end)
    colors = Enum.map(cards, fn card -> card.color end)
    numbers = Enum.map(cards, fn card -> card.number end)
    shapes = Enum.map(cards, fn card -> card.shape end)
    Enum.all?([patterns, colors, numbers, shapes], fn x -> Enum.member?([1, 3], length(Enum.uniq(x))) end)
  end

end
