defmodule BidsyncWeb.AuctionLive do
  use BidsyncWeb, :live_view
  
  alias Bidsync.AuctionServer
  alias Bidsync.Auctions

  @impl true
  def mount(_params, _session, socket) do
    auctions = Auctions.list_auctions()
    
    if connected?(socket) do
      Phoenix.PubSub.subscribe(Bidsync.PubSub, "auctions:bids")
    end

    bids = Map.new(auctions, fn auction ->
      {auction.id, AuctionServer.get_current_bid(auction.id)}
    end)

    {:ok, assign(socket, auctions: auctions, bids: bids)}
  end

  @impl true
  def handle_event("place_bid", %{"auctionid" => id_string, "amount" => amount_string}, socket) do
    auction_id = String.to_integer(id_string)
    amount = String.to_integer(amount_string)

    case AuctionServer.place_bid(auction_id, amount) do
      {:ok, _updated_amount} ->
        {:noreply, socket}

      {:error, reason} ->
        {:noreply, put_flash(socket, :error, reason)}
    end
  end

  @impl true
  def handle_info({:bid_updated, auction_id, new_amount}, socket) do
    current_bids = socket.assigns.bids

    updated_bids = Map.put(current_bids, auction_id, new_amount)
  
    {:noreply, assign(socket, bids: updated_bids)}
  end


  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-4xl mx-auto py-8">
      <h1 class="text-3xl font-bold mb-6">Active Auctions</h1>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <%= for auction <- @auctions do %>
          <div class="border p-4 rounded shadow-sm bg-white">
            <h2 class="text-xl text-black font-semibold"><%= auction.title %></h2>
            
            <div class="flex justify-between items-center mt-4">
              <span class="text-lg font-bold text-green-600">
                Current Bid: £<%= Map.get(@bids, auction.id, 0) %>
              </span>
              <form phx-submit="place_bid" class="flex items-center gap-2 mt-4">
              <input type="hidden" name="auctionid" value={auction.id} />
              <input 
                type="number" 
                name="amount" 
                id={"bid-amount-#{auction.id}"}
                placeholder="Enter amount..." 
                class="border p-2 rounded w-32 text-black"
                required 
                />
                <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
                  Place Bid
                </button>
              </form>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end

