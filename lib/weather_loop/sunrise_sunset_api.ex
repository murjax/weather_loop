defmodule WeatherLoop.SunriseSunsetApi do
  def get_data(latitude, longitude) do
    base_url = Application.get_env(:weather_loop, :sunrise_sunset_api_base_url)
    url = base_url <> "/json?lat=#{latitude}&lng=#{longitude}"
    url
    |> Tesla.get()
    |> decode_response()
    |> parse_attributes()
  end

  defp parse_attributes(%{"results" => results}) do
    Enum.reduce(results, %{}, fn {key, value}, acc -> Map.put(acc, String.to_atom(key), value) end)
    |> convert_times_to_epoch()
  end

  defp decode_response(response) do
    {:ok, %{body: body}} = response
    Jason.decode!(body)
  end

  defp convert_times_to_epoch(results) do
    date_fields = [
      :sunrise,
      :sunset,
      :first_light,
      :last_light,
      :dawn,
      :dusk,
      :solar_noon,
      :golden_hour
    ]
    date = results[:date]
    Enum.reduce(date_fields, results, fn key, acc -> Map.put(acc, key, build_datetime(date, results[key])) end)
  end

  defp build_datetime(date_string, time_string) do
    {:ok, date} = Date.from_iso8601(date_string)
    {:ok, time} = Timex.parse(time_string, "%k:%M:%S %p", :strftime)
    {:ok, time} = Time.new(time.hour, time.minute, time.second)
    {:ok, ndt} = NaiveDateTime.new(date, time)
    unix_epoch = ~N[1970-01-01 00:00:00]
    NaiveDateTime.diff(ndt, unix_epoch)
  end
end
