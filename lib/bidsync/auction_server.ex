defmodule Bidsync.AuctionServer do
  use GenServer

  def via_tuple(auction_id) do
    {:via, Registry, {Bidsync.AuctionRegistry, auction_id}}
  end

  def start_link(auction_id) do
    GenServer.start_link(__MODULE__, auction_id, name: via_tuple(auction_id))
  end

  def place_bid(auction_id, amount) do
    GenServer.call(via_tuple(auction_id), {:place_bid, amount})
  end

  def get_current_bid(auction_id) do
    GenServer.call(via_tuple(auction_id), {:get_bid})
  end

  @impl true
  def init(auction_id) do
    # Highest should ofc init as starting_bid from DB
    initial_state = %{auction_id: auction_id, highest_bid: 0}

    {:ok, initial_state}
  end

  @impl true
  def handle_call({:place_bid, amount}, _from, state) do
    if amount > state.highest_bid do
      new_state = %{state | highest_bid: amount}

      {:reply, {:ok, amount}, new_state}
    else
      {:reply, {:error, "Bid cannot be lower than #{state.highest_bid}"}, state}
    end
  end

  @impl true
  def handle_call({:get_bid}, _from, state) do
    {:reply, state.highest_bid, state}
  end

end
