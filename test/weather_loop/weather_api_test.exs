defmodule WeatherLoop.WeatherApiTest do
  use ExUnit.Case, async: true
  use WeatherLoop.RepoCase

  @city_name "Jacksonville Beach"

  setup _context do
    latitude = "30.2919324"
    longitude = "-81.4027473"

    city_attrs = %{name: @city_name, state: "FL", latitude: latitude, longitude: longitude}
    {:ok, city} = WeatherLoop.Cities.create_city(city_attrs)

    snapshot_attrs = %{
      temperature: 90.2,
      feels_like: 95.3,
      humidity: 70,
      weather_title: "Clear",
      weather_description: "Clear",
      weather_icon: "01d",
      city_id: city.id
    }
    {:ok, snapshot} = WeatherLoop.WeatherSnapshots.create_weather_snapshot(snapshot_attrs)

    {:ok, city: city, snapshot: snapshot}
  end

  test ".capture_snapshots", context do
    snapshots = WeatherLoop.WeatherApi.capture_snapshots(context[:city])
    [current_weather_snapshot | snapshots] = snapshots
    [forecast_weather_snapshot | _] = snapshots

    # Old snapshots for this city should be deleted.
    assert WeatherLoop.WeatherSnapshots.get_weather_snapshot(context[:snapshot].id) == nil

    assert current_weather_snapshot.temperature == 89.5
    assert current_weather_snapshot.feels_like == 80.38
    assert current_weather_snapshot.humidity == 89
    assert current_weather_snapshot.wind_speed == 10.36
    assert current_weather_snapshot.wind_direction == 150
    assert current_weather_snapshot.weather_title == "Clouds"
    assert current_weather_snapshot.weather_description == "broken clouds"
    assert current_weather_snapshot.weather_icon == "04d"
    assert current_weather_snapshot.sunrise == 1656671237
    assert current_weather_snapshot.sunset == 1656721881
    assert current_weather_snapshot.forecast == nil
    assert current_weather_snapshot.forecast_time == nil

    assert forecast_weather_snapshot.temperature == 89.5
    assert forecast_weather_snapshot.feels_like == 80.38
    assert forecast_weather_snapshot.humidity == 89
    assert forecast_weather_snapshot.weather_title == "Clouds"
    assert forecast_weather_snapshot.weather_description == "broken clouds"
    assert forecast_weather_snapshot.weather_icon == "04d"
    assert forecast_weather_snapshot.forecast == true
    assert forecast_weather_snapshot.forecast_time == 1656711307

    snapshots = WeatherLoop.WeatherApi.capture_snapshots(nil)
    assert snapshots == nil
  end
end
