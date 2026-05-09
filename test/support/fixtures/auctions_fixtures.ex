defmodule Bidsync.AuctionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bidsync.Auctions` context.
  """

  @doc """
  Generate a auction.
  """
  def auction_fixture(attrs \\ %{}) do
    {:ok, auction} =
      attrs
      |> Enum.into(%{
        starting_price: 42,
        title: "some title"
      })
      |> Bidsync.Auctions.create_auction()

    auction
  end
end
