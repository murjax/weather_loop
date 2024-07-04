defmodule WeatherLoop.DayForecasts.DecoratedDayForecast do
  @derive Jason.Encoder

  defstruct [
    :high_temperature,
    :low_temperature,
    :time,
    :primary_condition,
    :icon_url
  ]
end

defmodule WeatherLoop.DayForecasts.Decorator do
  alias WeatherLoop.DayForecasts.DecoratedDayForecast
  alias WeatherLoop.SnapshotConversions

  def decorate_collection(snapshots) do
    Enum.map(snapshots, fn snapshot -> decorate(snapshot) end)
  end

  def decorate(snapshot) do
    %DecoratedDayForecast{
      high_temperature: round(snapshot.high_temperature),
      low_temperature: round(snapshot.low_temperature),
      time: SnapshotConversions.format_snapshot_day(snapshot.time, snapshot.time_zone),
      primary_condition: snapshot.primary_condition,
      icon_url: SnapshotConversions.icon_url(snapshot.weather_icon)
    }
  end
end
