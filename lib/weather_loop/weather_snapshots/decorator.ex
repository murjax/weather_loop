defmodule WeatherLoop.WeatherSnapshots.DecoratedWeatherSnapshot do
  @derive Jason.Encoder

  defstruct [
    :temperature,
    :feels_like,
    :humidity,
    :visibility,
    :wind,
    :weather_title,
    :icon_url,
    :dawn,
    :dusk,
    :sunrise,
    :sunset,
    :forecast_time,
    :forecast
  ]
end

defmodule WeatherLoop.WeatherSnapshots.Decorator do
  alias WeatherLoop.WeatherSnapshots.DecoratedWeatherSnapshot
  alias WeatherLoop.SnapshotConversions

  def decorate_collection(snapshots) do
    Enum.map(snapshots, fn snapshot -> decorate(snapshot) end)
  end

  def decorate(snapshot) do
    %DecoratedWeatherSnapshot{
      temperature: round(snapshot.temperature),
      feels_like: round(snapshot.feels_like),
      humidity: snapshot.humidity,
      visibility: SnapshotConversions.visibility_miles(snapshot.visibility),
      wind: SnapshotConversions.wind_detail(snapshot.wind_direction, snapshot.wind_speed),
      weather_title: snapshot.weather_title,
      icon_url: SnapshotConversions.icon_url(snapshot.weather_icon),
      dawn: SnapshotConversions.format_snapshot_time(snapshot.dawn, snapshot.city.time_zone),
      dusk: SnapshotConversions.format_snapshot_time(snapshot.dusk, snapshot.city.time_zone),
      sunrise: SnapshotConversions.format_snapshot_time(snapshot.sunrise, snapshot.city.time_zone),
      sunset: SnapshotConversions.format_snapshot_time(snapshot.sunset, snapshot.city.time_zone),
      forecast_time: SnapshotConversions.format_snapshot_time(snapshot.forecast_time, snapshot.city.time_zone),
      forecast: snapshot.forecast
    }
  end
end
