defmodule BidsyncWeb.PageController do
  use BidsyncWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
