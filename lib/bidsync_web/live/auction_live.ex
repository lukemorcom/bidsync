defmodule BidsyncWeb.AuctionLive do
  use BidsyncWeb, :live_view
  
  alias Bidsync.AuctionServer
  alias Bidsync.AuctionManager
  alias Bidsync.Auctions

  @impl true
  def mount(_params, _session, socket) do
    auctions = Auctions.list_auctions()
    
    Enum.each(auctions, fn auction -> 
      AuctionManager.ensure_started(auction.id)
    end)

    bids = Map.new(auctions, fn auction ->
      {auction.id, AuctionServer.get_current_bid(auction.id)}
    end)

    {:ok, assign(socket, auctions: auctions, bids: bids)}
  end

  @impl true
  def handle_event("place_bid", %{"id" => id_string}, socket) do
    auction_id = String.to_integer(id_string)
    current_bid = Map.get(socket.assigns.bids, auction_id, 0)
    new_bid = current_bid + 10

    case AuctionServer.place_bid(auction_id, new_bid) do
      {:ok, updated_amount} ->
        updated_bids = Map.put(socket.assigns.bids, auction_id, updated_amount)
        {:noreply, assign(socket, bids: updated_bids)}

      {:error, reason} ->
        {:noreply, put_flash(socket, :error, reason)}
    end
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
              
              <button 
                phx-click="place_bid" 
                phx-value-id={auction.id}
                class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
              >
                Bid +£10
              </button>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end

