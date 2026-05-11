alias Bidsync.Auctions

auctions_data = [
  %{title: "Antique Watch", starting_price: 500_00},
  %{title: "Elixir In Action", starting_price: 25_00},
  %{title: "Spaghetti Bolognese", starting_price: 149_99}
]

Enum.each(auctions_data, fn data -> Auctions.create_auction(data) end)

IO.puts("Auctions seeded")
