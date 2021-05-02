defmodule ConsumerEdgeWeb.PageController do
  use ConsumerEdgeWeb, :controller

  def index(conn, _params) do
    chart =
    "aapl"
    |> Marketstack.end_of_day
    |> Poison.encode!
    |> Chartkick.column_chart

    render(conn, "index.html", chart: chart)
  end
end
