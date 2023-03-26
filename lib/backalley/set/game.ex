defmodule Backalley.Set.Game do
  use Ecto.Schema
  alias Backalley.Accounts.User

  @schema_prefix "set"
  schema "games" do
    field :name, :string
    field :public, :boolean, default: true
    belongs_to :creator, User, foreign_key: :created_by
  end


end
