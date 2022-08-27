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

    city_attrs = %{name: @city_name, state: "FL", latitude: latitude, longitude: longitude}
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
      sunrise: 1661638652,
      sunset: 1661638656,
      forecast_time: 1661638673,
      forecast: true,
      city_id: city.id
    }
    {:ok, snapshot} = WeatherLoop.WeatherSnapshots.create_weather_snapshot(snapshot_attrs)

    {:ok, snapshot: snapshot}
  end

  test ".decorate", context do
    snapshot = context[:snapshot]
    expected_decorated_snapshot = %DecoratedWeatherSnapshot{
      temperature: round(snapshot.temperature),
      feels_like: round(snapshot.feels_like),
      humidity: snapshot.humidity,
      visibility: SnapshotConversions.visibility_miles(snapshot.visibility),
      wind: SnapshotConversions.wind_detail(snapshot.wind_direction, snapshot.wind_speed),
      weather_title: snapshot.weather_title,
      icon_url: SnapshotConversions.icon_url(snapshot.weather_icon),
      sunrise: SnapshotConversions.convert_epoch(snapshot.sunrise),
      sunset: SnapshotConversions.convert_epoch(snapshot.sunset),
      forecast_time: SnapshotConversions.convert_epoch(snapshot.forecast_time),
      forecast: snapshot.forecast
    }

    decorated_snapshot = Decorator.decorate(snapshot)

    assert decorated_snapshot == expected_decorated_snapshot
  end

  test ".decorate_collection", context do
    snapshot = context[:snapshot]
    expected_decorated_snapshot = %DecoratedWeatherSnapshot{
      temperature: round(snapshot.temperature),
      feels_like: round(snapshot.feels_like),
      humidity: snapshot.humidity,
      visibility: SnapshotConversions.visibility_miles(snapshot.visibility),
      wind: SnapshotConversions.wind_detail(snapshot.wind_direction, snapshot.wind_speed),
      weather_title: snapshot.weather_title,
      icon_url: SnapshotConversions.icon_url(snapshot.weather_icon),
      sunrise: SnapshotConversions.convert_epoch(snapshot.sunrise),
      sunset: SnapshotConversions.convert_epoch(snapshot.sunset),
      forecast_time: SnapshotConversions.convert_epoch(snapshot.forecast_time),
      forecast: snapshot.forecast
    }

    decorated_collection = Decorator.decorate_collection([snapshot])

    assert decorated_collection == [expected_decorated_snapshot]
  end
end
