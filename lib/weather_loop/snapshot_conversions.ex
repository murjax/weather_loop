defmodule WeatherLoop.SnapshotConversions do
  def visibility_miles(nil), do: nil
  def visibility_miles(visibility_meters) do
    visibility_meters / 1609.344
    |> round
  end

  def cardinal_direction(nil), do: nil
  def cardinal_direction(direction_degrees) do
    case direction_degrees do
      x when x in 0..11 ->
        "N"
      x when x in 12..33 ->
        "NNE"
      x when x in 34..56 ->
        "NE"
      x when x in 57..78 ->
        "ENE"
      x when x in 79..101 ->
        "E"
      x when x in 102..123 ->
        "ESE"
      x when x in 124..146 ->
        "SE"
      x when x in 147..168 ->
        "SSE"
      x when x in 169..191 ->
        "S"
      x when x in 192..213 ->
        "SSW"
      x when x in 214..236 ->
        "SW"
      x when x in 237..258 ->
        "WSW"
      x when x in 259..281 ->
        "W"
      x when x in 282..303 ->
        "WNW"
      x when x in 304..326 ->
        "NW"
      x when x in 327..348 ->
        "NNW"
      x when x in 349..360 ->
        "N"
    end
  end

  def wind_detail(nil, nil), do: nil
  def wind_detail(wind_direction, wind_speed) do
    "#{cardinal_direction(wind_direction)} at #{round(wind_speed)} mph"
  end

  def format_snapshot_day(nil, _), do: nil
  def format_snapshot_day(datetime, time_zone) do
    {:ok, time_string} = datetime
    |> Calendar.DateTime.shift_zone!(time_zone)
    |> Calendar.Strftime.strftime("%m/%d")

    time_string
  end

  def format_snapshot_time(nil, _), do: nil
  def format_snapshot_time(datetime, time_zone) do
    {:ok, time_string} = datetime
    |> Calendar.DateTime.shift_zone!(time_zone)
    |> Calendar.Strftime.strftime("%I:%M%P")

    time_string
  end

  def icon_url(weather_icon) do
    "http://openweathermap.org/img/wn/#{weather_icon}.png"
  end
end
