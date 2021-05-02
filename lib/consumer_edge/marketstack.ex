defmodule Marketstack do
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
        |> Poison.decode!
        |> Map.get("data")
        |> Enum.map(&([Map.get(&1, "date"), Map.get(&1, "close")]))
        |> Enum.reduce(%{}, fn([date, close], acc) -> Map.put(acc, date, close) end)
    end
  end
end
