defmodule Bidsync.AuctionManager do
  alias Bidsync.AuctionServer

  def ensure_started(auction_id) do
    DynamicSupervisor.start_child(Bidsync.AuctionSupervisor, {AuctionServer, auction_id})
  end
end
