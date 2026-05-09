# Bidsync

A workbench of a project for me to play around with as I learn Elixir and Phoenix.

The code here is almost certainly not fit for production!


## To start the app:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


## In case you don't have any Postgres to hand:

* Run `docker run --name bidsync-postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres` to bring up a DB in Docker with the defaults Phoenix expects
