defmodule WeatherLoop.DayForecasts.DecoratorTest do
  use ExUnit.Case, async: true

  alias WeatherLoop.DayForecasts.Decorator
  alias WeatherLoop.DayForecasts.DecoratedDayForecast
  alias WeatherLoop.SnapshotConversions

  test ".decorate" do
    snapshot = %{
      high_temperature: 80.6,
      low_temperature: 72.2,
      time: 1661639249,
      primary_condition: "Clear",
      weather_icon: "03d"
    }

    expected_decorated_snapshot = %DecoratedDayForecast{
      high_temperature: round(snapshot.high_temperature),
      low_temperature: round(snapshot.low_temperature),
      time: SnapshotConversions.convert_epoch_day(snapshot.time),
      primary_condition: snapshot.primary_condition,
      icon_url: SnapshotConversions.icon_url(snapshot.weather_icon)
    }

    decorated_snapshot = Decorator.decorate(snapshot)

    assert decorated_snapshot == expected_decorated_snapshot
  end

  test ".decorate_collection" do
    snapshot = %{
      high_temperature: 80.6,
      low_temperature: 72.2,
      time: 1661639249,
      primary_condition: "Clear",
      weather_icon: "03d"
    }

    expected_decorated_snapshot = %DecoratedDayForecast{
      high_temperature: round(snapshot.high_temperature),
      low_temperature: round(snapshot.low_temperature),
      time: SnapshotConversions.convert_epoch_day(snapshot.time),
      primary_condition: snapshot.primary_condition,
      icon_url: SnapshotConversions.icon_url(snapshot.weather_icon)
    }

    decorated_collection = Decorator.decorate_collection([snapshot])

    assert decorated_collection == [expected_decorated_snapshot]
  end
end
