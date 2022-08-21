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
      sunrise: SnapshotConversions.convert_epoch(snapshot.sunrise),
      sunset: SnapshotConversions.convert_epoch(snapshot.sunset),
      forecast_time: SnapshotConversions.convert_epoch(snapshot.forecast_time),
      forecast: snapshot.forecast
    }
  end
end
