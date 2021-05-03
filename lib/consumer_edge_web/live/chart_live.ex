defmodule ConsumerEdgeWeb.ChartLive do
  @moduledoc nil

  use Phoenix.LiveView
  use Phoenix.HTML

  alias Ecto.UUID

  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :tick, 1000)
    {:ok, assign(socket, :chart_id, UUID.generate())}
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 1000)
    {:noreply, socket}
  end

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

  def render(assigns) do
    ~L"""
    <article class="chart-tile">
      <form action="#" class="ticker-selector" id="chart-form-<%= @chart_id %>" phx-submit="select-chart" phx-hook="SelectTicker">
        <input type="hidden" name="chart_id" value="<%= @chart_id %>"/>

        <div class="ticker-select-header">
          <input type="text" autocomplete="off" name="ticker" class="ticker-input" placeholder="Ticker symbol..." value="<%= assigns[:ticker] %>">

          <fieldset class="chart-type-select">
            <label class="btn btn-secondary <%= assigns[:type_line] %>"
              phx-click="select-chart"
              phx-value-chart_id="<%= @chart_id %>"
              phx-value-ticker="<%= assigns[:ticker] %>"
              phx-value-type="line"
            > Line
              <input type="radio" class="btn-check" name="type" value="line" checked>
            </label>

            <label class="btn btn-secondary <%= assigns[:type_bar] %>"
              phx-click="select-chart"
              phx-value-chart_id="<%= @chart_id %>"
              phx-value-ticker="<%= assigns[:ticker] %>"
              phx-value-type="bar"
            > Bar
              <input type="radio" class="btn-check" name="type" value="bar">
            </label>
          </fieldset>
        </div>
      </form>

      <%= raw assigns[:chart] %>
    </article>
    """
  end

  defp generate_chart("", _chart_type, _chart_id), do: nil
  defp generate_chart(ticker, chart_type, chart_id) do
    ticker
      |> Marketstack.end_of_day
      |> Poison.encode!
      |> build_chart(chart_type, chart_id)
  end

  defp build_chart(json, "line", id), do: Chartkick.line_chart(json, id: id)
  defp build_chart(json, "bar", id), do: Chartkick.column_chart(json, id: id)
  defp build_chart(_json, _chart_type, _id), do: ""

  defp selected_type_class(:line, "line"), do: "btn-selected"
  defp selected_type_class(:bar, "bar"), do: "btn-selected"
  defp selected_type_class(_, _), do: nil
end
