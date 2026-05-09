defmodule Bidsync.Repo.Migrations.CreateAuctions do
  use Ecto.Migration

  def change do
    create table(:auctions) do
      add :title, :string
      add :starting_price, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
