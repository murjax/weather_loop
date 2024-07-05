defmodule WeatherLoop.WeatherApi do
  alias WeatherLoop.Cities.City
  alias WeatherLoop.CurrentWeatherApi
  alias WeatherLoop.ForecastWeatherApi
  alias WeatherLoop.SunriseSunsetApi
  alias WeatherLoop.WeatherSnapshots

  def capture_snapshots(%City{} = city) do
    city
    |> delete_old_snapshots
    |> get_weather_info
    |> create_snapshots
  end

  def capture_snapshots(nil), do: nil

  defp delete_old_snapshots(%City{} = city) do
    WeatherSnapshots.delete_snapshots_for_city_id(city.id)
    city
  end

  defp get_weather_info(%City{} = city) do
    current_weather_info = get_current_weather_info(city)
    forecast_weather_info = get_forecast_weather_info(city)

    %{current: current_weather_info, forecast: forecast_weather_info}
  end

  defp get_current_weather_info(city) do
    data = CurrentWeatherApi.get_current_weather_info(city)
    sunrise_sunset_data = SunriseSunsetApi.get_data(city.latitude, city.longitude)

    if sunrise_sunset_data != %{} do
      data
      |> Map.put(:dawn, sunrise_sunset_data[:dawn])
      |> Map.put(:dusk, sunrise_sunset_data[:dusk])
    else
      data
    end
  end

  defp get_forecast_weather_info(city) do
    ForecastWeatherApi.get_forecast_weather_info(city)
  end

  defp create_snapshots(weather_info_set) do
    current_weather_snapshot = create_snapshot(weather_info_set[:current])
    forecast_snapshots = Enum.map(weather_info_set[:forecast], fn weather_info -> create_snapshot(weather_info) end)
    [current_weather_snapshot | forecast_snapshots]
    |> Enum.reject(& &1 == nil)
  end

  defp create_snapshot(attributes) when attributes == %{}, do: nil
  defp create_snapshot(attributes) do
    result = WeatherSnapshots.create_weather_snapshot(attributes)
    {:ok, snapshot} = result
    snapshot
  end
end
