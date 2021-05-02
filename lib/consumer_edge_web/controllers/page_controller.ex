defmodule ConsumerEdgeWeb.PageController do
  use ConsumerEdgeWeb, :controller

  def index(conn, _params) do
    data = Poison.encode!(Marketstack.eod("aapl"))
    render(conn, "index.html", json: data)
  end
end
