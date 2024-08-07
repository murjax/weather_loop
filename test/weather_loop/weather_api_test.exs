defmodule WeatherLoop.WeatherApiTest do
  use ExUnit.Case, async: true
  use WeatherLoop.RepoCase

  test ".capture_snapshots" do
    city_name = "Jacksonville Beach"
    latitude = "30.2919324"
    longitude = "-81.4027473"
    time_zone = "America/New_York"

    city_attrs = %{
      name: city_name,
      state: "FL",
      latitude: latitude,
      longitude: longitude,
      time_zone: time_zone
    }
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
    snapshots = WeatherLoop.WeatherApi.capture_snapshots(city)

    [current_weather_snapshot | snapshots] = snapshots
    [forecast_weather_snapshot | _] = snapshots

    # Old snapshots for this city should be deleted.
    assert WeatherLoop.WeatherSnapshots.get_weather_snapshot(snapshot.id) == nil

    assert current_weather_snapshot.temperature == 89.5
    assert current_weather_snapshot.feels_like == 80.38
    assert current_weather_snapshot.humidity == 89
    assert current_weather_snapshot.wind_speed == 10.36
    assert current_weather_snapshot.wind_direction == 150
    assert current_weather_snapshot.weather_title == "Clouds"
    assert current_weather_snapshot.weather_description == "broken clouds"
    assert current_weather_snapshot.weather_icon == "04d"
    assert current_weather_snapshot.sunrise == ~U[2024-07-04 09:49:21Z]
    assert current_weather_snapshot.sunset == ~U[2024-07-05 00:38:08Z]
    assert current_weather_snapshot.dawn == ~U[2024-07-04 09:17:35Z]
    assert current_weather_snapshot.dusk == ~U[2024-07-05 01:09:54Z]
    assert current_weather_snapshot.forecast == nil
    assert current_weather_snapshot.forecast_time == nil

    assert forecast_weather_snapshot.temperature == 89.5
    assert forecast_weather_snapshot.feels_like == 80.38
    assert forecast_weather_snapshot.humidity == 89
    assert forecast_weather_snapshot.weather_title == "Clouds"
    assert forecast_weather_snapshot.weather_description == "broken clouds"
    assert forecast_weather_snapshot.weather_icon == "04d"
    assert forecast_weather_snapshot.sunrise == ~U[2024-07-04 09:49:21Z]
    assert forecast_weather_snapshot.sunset == ~U[2024-07-05 00:38:08Z]
    assert forecast_weather_snapshot.dawn == ~U[2024-07-04 09:17:35Z]
    assert forecast_weather_snapshot.dusk == ~U[2024-07-05 01:09:54Z]
    assert forecast_weather_snapshot.forecast == true
    assert forecast_weather_snapshot.forecast_time == ~U[2022-07-01 21:35:07Z]

    snapshots = WeatherLoop.WeatherApi.capture_snapshots(nil)
    assert snapshots == nil
  end

  test ".capture_snapshots failure" do
    city_name = "Green Cove Springs"
    latitude = "30.0425055"
    longitude = "-81.7312244"

    city_attrs = %{name: city_name, state: "FL", latitude: latitude, longitude: longitude}
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

    snapshots = WeatherLoop.WeatherApi.capture_snapshots(city)

    # Old snapshots for this city should be deleted.
    assert WeatherLoop.WeatherSnapshots.get_weather_snapshot(snapshot.id) == nil

    assert snapshots == []
  end
end
