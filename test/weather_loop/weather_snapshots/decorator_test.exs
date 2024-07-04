defmodule WeatherLoop.WeatherSnapshots.DecoratorTest do
  use ExUnit.Case, async: true
  use WeatherLoop.RepoCase

  alias WeatherLoop.WeatherSnapshots.Decorator
  alias WeatherLoop.WeatherSnapshots.DecoratedWeatherSnapshot
  alias WeatherLoop.SnapshotConversions

  @city_name "Jacksonville Beach"

  setup _context do
    latitude = "30.2919324"
    longitude = "-81.4027473"
    time_zone = "America/New_York"

    city_attrs = %{
      name: @city_name,
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
      visibility: 59,
      wind_direction: 180,
      wind_speed: 10.7,
      weather_title: "Clear",
      weather_description: "Clear",
      weather_icon: "01d",
      dawn: ~U[2024-07-04 10:00:00Z],
      dusk: ~U[2024-07-04 22:00:00Z],
      sunrise: ~U[2024-07-04 10:30:00Z],
      sunset: ~U[2024-07-04 22:30:00Z],
      forecast_time: ~U[2024-07-04 12:00:00Z],
      forecast: true,
      city_id: city.id
    }
    {:ok, snapshot} = WeatherLoop.WeatherSnapshots.create_weather_snapshot(snapshot_attrs)
    snapshot = WeatherLoop.Repo.preload(snapshot, :city)

    {:ok, snapshot: snapshot, time_zone: time_zone}
  end

  test ".decorate", context do
    snapshot = context[:snapshot]
    time_zone = context[:time_zone]
    expected_decorated_snapshot = %DecoratedWeatherSnapshot{
      temperature: round(snapshot.temperature),
      feels_like: round(snapshot.feels_like),
      humidity: snapshot.humidity,
      visibility: SnapshotConversions.visibility_miles(snapshot.visibility),
      wind: SnapshotConversions.wind_detail(snapshot.wind_direction, snapshot.wind_speed),
      weather_title: snapshot.weather_title,
      icon_url: SnapshotConversions.icon_url(snapshot.weather_icon),
      dawn: SnapshotConversions.format_snapshot_time(snapshot.dawn, time_zone),
      dusk: SnapshotConversions.format_snapshot_time(snapshot.dusk, time_zone),
      sunrise: SnapshotConversions.format_snapshot_time(snapshot.sunrise, time_zone),
      sunset: SnapshotConversions.format_snapshot_time(snapshot.sunset, time_zone),
      forecast_time: SnapshotConversions.format_snapshot_time(snapshot.forecast_time, time_zone),
      forecast: snapshot.forecast
    }

    decorated_snapshot = Decorator.decorate(snapshot)

    assert decorated_snapshot == expected_decorated_snapshot
  end

  test ".decorate_collection", context do
    snapshot = context[:snapshot]
    time_zone = context[:time_zone]
    expected_decorated_snapshot = %DecoratedWeatherSnapshot{
      temperature: round(snapshot.temperature),
      feels_like: round(snapshot.feels_like),
      humidity: snapshot.humidity,
      visibility: SnapshotConversions.visibility_miles(snapshot.visibility),
      wind: SnapshotConversions.wind_detail(snapshot.wind_direction, snapshot.wind_speed),
      weather_title: snapshot.weather_title,
      icon_url: SnapshotConversions.icon_url(snapshot.weather_icon),
      dawn: SnapshotConversions.format_snapshot_time(snapshot.dawn, time_zone),
      dusk: SnapshotConversions.format_snapshot_time(snapshot.dusk, time_zone),
      sunrise: SnapshotConversions.format_snapshot_time(snapshot.sunrise, time_zone),
      sunset: SnapshotConversions.format_snapshot_time(snapshot.sunset, time_zone),
      forecast_time: SnapshotConversions.format_snapshot_time(snapshot.forecast_time, time_zone),
      forecast: snapshot.forecast
    }

    decorated_collection = Decorator.decorate_collection([snapshot])

    assert decorated_collection == [expected_decorated_snapshot]
  end
end
