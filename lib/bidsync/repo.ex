defmodule Bidsync.Repo do
  use Ecto.Repo,
    otp_app: :bidsync,
    adapter: Ecto.Adapters.Postgres
end
