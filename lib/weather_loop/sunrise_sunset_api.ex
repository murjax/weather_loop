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
    |> convert_times_to_datetime()
  end

  defp decode_response(response) do
    {:ok, %{body: body}} = response
    Jason.decode!(body)
  end

  defp convert_times_to_datetime(results) do
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
    date_string = results[:date]
    time_zone = results[:timezone]
    {:ok, date} = Date.from_iso8601(date_string)

    Enum.reduce(
      date_fields,
      results,
      fn key, acc -> Map.put(acc, key, build_datetime(date, time_zone, results[key])) end
    )
  end

  defp build_datetime(date, time_zone, time_string) do
    {:ok, time} = Timex.parse(time_string, "%k:%M:%S %p", :strftime)
    {:ok, time} = Time.new(time.hour, time.minute, time.second)
    {:ok, datetime} = DateTime.new(date, time, time_zone)
    datetime |> Calendar.DateTime.shift_zone!("UTC")
  end
end
