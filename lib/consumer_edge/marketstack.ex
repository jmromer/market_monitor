defmodule Marketstack do
  @base_url "http://api.marketstack.com/v1"
  @access_key System.get_env("MARKETSTACK_API_KEY")

  def eod(ticker) do
    url = @base_url <> "/eod?access_key=" <> @access_key <> "&symbols=" <> ticker

    case HTTPoison.get(url) do
      {:error, %{reason: reason}} ->
        {:error, reason}
      {:ok, %{body: raw_body, status_code: code}} ->
        raw_body
        |> Poison.decode!
        |> Map.get("data")
        |> Enum.map(&(extract_response(&1)))
    end
  end

  defp extract_response(daily_entry) do
    daily_entry
    |> Map.take(~w(date close))
    |> format_values
  end

  defp format_values(%{"date" => timestamp, "close" => close}) do
    %{close: close, date: timestamp |> String.split("T") |> List.first}
  end
end
