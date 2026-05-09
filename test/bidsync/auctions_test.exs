defmodule Bidsync.AuctionsTest do
  use Bidsync.DataCase

  alias Bidsync.Auctions

  describe "auctions" do
    alias Bidsync.Auctions.Auction

    import Bidsync.AuctionsFixtures

    @invalid_attrs %{title: nil, starting_price: nil}

    test "list_auctions/0 returns all auctions" do
      auction = auction_fixture()
      assert Auctions.list_auctions() == [auction]
    end

    test "get_auction!/1 returns the auction with given id" do
      auction = auction_fixture()
      assert Auctions.get_auction!(auction.id) == auction
    end

    test "create_auction/1 with valid data creates a auction" do
      valid_attrs = %{title: "some title", starting_price: 42}

      assert {:ok, %Auction{} = auction} = Auctions.create_auction(valid_attrs)
      assert auction.title == "some title"
      assert auction.starting_price == 42
    end

    test "create_auction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auctions.create_auction(@invalid_attrs)
    end

    test "update_auction/2 with valid data updates the auction" do
      auction = auction_fixture()
      update_attrs = %{title: "some updated title", starting_price: 43}

      assert {:ok, %Auction{} = auction} = Auctions.update_auction(auction, update_attrs)
      assert auction.title == "some updated title"
      assert auction.starting_price == 43
    end

    test "update_auction/2 with invalid data returns error changeset" do
      auction = auction_fixture()
      assert {:error, %Ecto.Changeset{}} = Auctions.update_auction(auction, @invalid_attrs)
      assert auction == Auctions.get_auction!(auction.id)
    end

    test "delete_auction/1 deletes the auction" do
      auction = auction_fixture()
      assert {:ok, %Auction{}} = Auctions.delete_auction(auction)
      assert_raise Ecto.NoResultsError, fn -> Auctions.get_auction!(auction.id) end
    end

    test "change_auction/1 returns a auction changeset" do
      auction = auction_fixture()
      assert %Ecto.Changeset{} = Auctions.change_auction(auction)
    end
  end
end
