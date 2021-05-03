MarketMonitor
============

Demo
----

![demo](docs/demo.gif)

See it live at http://marketmonitor.gigalixirapp.com.

Requirements
------------

A `.tool-versions` file is provided for the ASDF version manager.
Issue `asdf install` to install requirements.

- Elixir 1.11.4
- Erlang 23.3.2
- Node.js 16.0.0
- PostgreSQL 13.0

Dependencies
------------

See `mix.exs` and `assets/package.json` for complete list and versions.

- Phoenix (web framework)
- Phoenix LiveView (server-side rendering)
- Pow (authentication)
- Nebulex (caching)
- Distillery (deployment)
- Chartkick (charting)
- Highcharts (charting)


Development
------------

* Install requirements with `asdf install`.
* Install dependencies with `mix deps.get`.
* Create and migrate your database with `mix ecto.setup`.
* If needed, create a root postgres role with `createuser -s postgres`.
* Install Node.js dependencies with `npm install --prefix assets`.
* Start Phoenix endpoint with `mix phx.server`.

Visit [`localhost:4000`](http://localhost:4000) from your browser.

NB: A `MARKETSTACK_API_KEY` env var must be set to source data from the API.

Walkthrough
-----------

The dashboard template is served from the root url, which is auth-protected.

```ex
# lib/consumer_edge_web/router.ex L30-34 (263c0785)

scope "/", ConsumerEdgeWeb do
  pipe_through [:browser, :protected]

  get "/", PageController, :index
end
```
<sup>[[source](https://github.com/jmromer/market_monitor/blob/263c0785/lib/consumer_edge_web/router.ex#L30-L34)]</sup>

Charts are live-rendered using Phoenix LiveView:

```eex
<!-- lib/consumer_edge_web/templates/page/index.html.eex L33 (4487b478) -->

<%= live_render(@conn, ConsumerEdgeWeb.ChartLive) %>
```
<sup>[[source](https://github.com/jmromer/market_monitor/blob/4487b478/lib/consumer_edge_web/templates/page/index.html.eex#L33-L33)]</sup>

Changes to the chart tiles (stock ticker, chart type) are handled by
`handle_event`, which prepares local assigns before re-rendering:

```ex
 # lib/consumer_edge_web/live/chart_live.ex L19-31 (25d71b37)

def handle_event("select-chart", params, socket) do
  %{"type" => chart_type, "ticker" => ticker, "chart_id" => chart_id} = params

  socket =
    socket
    |> assign(:ticker, String.upcase(ticker))
    |> assign(:type, chart_type)
    |> assign(:type_line, selected_type_class(:line, chart_type))
    |> assign(:type_bar, selected_type_class(:bar, chart_type))
    |> assign(:chart, generate_chart(ticker, chart_type, chart_id))

  {:noreply, socket}
end
```
<sup>[[source](https://github.com/jmromer/market_monitor/blob/25d71b37/lib/consumer_edge_web/live/chart_live.ex#L19-L31)]</sup>


Ticker data is sourced from the Marketstack API:

```ex
# lib/consumer_edge_web/live/chart_live.ex L70-75 (25d71b37)

defp generate_chart(ticker, chart_type, chart_id) do
  ticker
    |> Marketstack.end_of_day
    |> Poison.encode!
    |> build_chart(chart_type, chart_id)
end
```
<sup>[[source](https://github.com/jmromer/market_monitor/blob/25d71b37/lib/consumer_edge_web/live/chart_live.ex#L70-L75)]</sup>

```ex
# lib/consumer_edge/marketstack.ex L12-27 (a47a9963)

@decorate cacheable(cache: ConsumerEdge.Cache, key: {:eod, ticker}, opts: [ttl: @ttl])
def end_of_day(ticker) do
  url = @base_url <> "/eod?access_key=" <> @access_key <> "&symbols=" <> ticker

  case HTTPoison.get(url) do
    {:error, %{reason: reason}} ->
      %{error: reason}

    {:ok, %{body: raw_body}} ->
      raw_body
      |> Poison.decode!()
      |> Map.get("data")
      |> Enum.map(fn %{"date" => timestamp, "close" => price} -> [timestamp, price] end)
      |> Enum.map(&extract_date_and_eod_price/1)
  end
end
```
<sup>[[source](https://github.com/jmromer/market_monitor/blob/a47a9963/lib/consumer_edge/marketstack.ex#L12-L27)]</sup>

Omissions
---------

Since this is a proof of concept, automated tests were omitted for expediency,
and the sole stylesheet is organized in an ad-hoc manner.
