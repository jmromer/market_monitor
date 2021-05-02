defmodule ConsumerEdgeWeb.PageController do
  use ConsumerEdgeWeb, :controller

  def index(conn, _params) do
    data = Poison.encode!(Marketstack.end_of_day("aapl"))
    render(conn, "index.html", json: data)
  end
end
