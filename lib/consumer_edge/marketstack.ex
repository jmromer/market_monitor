defmodule Marketstack do
  @moduledoc "Marketstack API client"

  use Timex

  use Nebulex.Caching
  @ttl :timer.minutes(10)

  @base_url "http://api.marketstack.com/v1"
  @access_key System.get_env("MARKETSTACK_API_KEY")

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

  defp extract_date_and_eod_price([timestamp, price]) do
    date =
      timestamp
      |> String.split("T")
      |> List.first()
      |> Timex.parse!("{YYYY}-{0M}-{0D}")
      |> Timex.format!("%b %-d", :strftime)

    [date, price]
  end
end
