defmodule Bidsync.Auctions.Auction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "auctions" do
    field :title, :string
    field :starting_price, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(auction, attrs) do
    auction
    |> cast(attrs, [:title, :starting_price])
    |> validate_required([:title, :starting_price])
  end
end
