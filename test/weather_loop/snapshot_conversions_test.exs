defmodule WeatherLoop.SnapshotConversionsTest do
  use ExUnit.Case, async: true
  alias WeatherLoop.SnapshotConversions

  test ".visibility_miles" do
    meters = 1609.344
    expected_miles = 1
    miles = SnapshotConversions.visibility_miles(meters)
    assert miles == expected_miles

    miles = SnapshotConversions.visibility_miles(nil)
    assert miles == nil
  end

  test ".cardinal_direction" do
    degrees = 10
    expected_direction = "N"
    direction = SnapshotConversions.cardinal_direction(degrees)
    assert direction == expected_direction

    degrees = 20
    expected_direction = "NNE"
    direction = SnapshotConversions.cardinal_direction(degrees)
    assert direction == expected_direction

    degrees = 40
    expected_direction = "NE"
    direction = SnapshotConversions.cardinal_direction(degrees)
    assert direction == expected_direction

    degrees = 60
    expected_direction = "ENE"
    direction = SnapshotConversions.cardinal_direction(degrees)
    assert direction == expected_direction

    degrees = 90
    expected_direction = "E"
    direction = SnapshotConversions.cardinal_direction(degrees)
    assert direction == expected_direction

    degrees = 110
    expected_direction = "ESE"
    direction = SnapshotConversions.cardinal_direction(degrees)
    assert direction == expected_direction

    degrees = 130
    expected_direction = "SE"
    direction = SnapshotConversions.cardinal_direction(degrees)
    assert direction == expected_direction

    degrees = 180
    expected_direction = "S"
    direction = SnapshotConversions.cardinal_direction(degrees)
    assert direction == expected_direction

    degrees = 200
    expected_direction = "SSW"
    direction = SnapshotConversions.cardinal_direction(degrees)
    assert direction == expected_direction

    degrees = 220
    expected_direction = "SW"
    direction = SnapshotConversions.cardinal_direction(degrees)
    assert direction == expected_direction

    degrees = 270
    expected_direction = "W"
    direction = SnapshotConversions.cardinal_direction(degrees)
    assert direction == expected_direction

    degrees = 290
    expected_direction = "WNW"
    direction = SnapshotConversions.cardinal_direction(degrees)
    assert direction == expected_direction

    degrees = 310
    expected_direction = "NW"
    direction = SnapshotConversions.cardinal_direction(degrees)
    assert direction == expected_direction

    degrees = 330
    expected_direction = "NNW"
    direction = SnapshotConversions.cardinal_direction(degrees)
    assert direction == expected_direction

    degrees = 350
    expected_direction = "N"
    direction = SnapshotConversions.cardinal_direction(degrees)
    assert direction == expected_direction

    direction = SnapshotConversions.cardinal_direction(nil)
    assert direction == nil
  end

  test ".wind_detail" do
    wind_direction = 330
    wind_speed = 2.6
    expected_wind_detail = "NNW at 3 mph"
    wind_detail = SnapshotConversions.wind_detail(wind_direction, wind_speed)
    assert wind_detail == expected_wind_detail

    wind_detail = SnapshotConversions.wind_detail(nil, nil)
    assert wind_detail == nil
  end

  test ".format_snapshot_time" do
    time_zone = "America/New_York"
    datetime = ~U[2024-07-04 12:00:00Z]
    expected_formatted_time = "08:00am"
    formatted_time = SnapshotConversions.format_snapshot_time(datetime, time_zone)
    assert formatted_time == expected_formatted_time

    formatted_time = SnapshotConversions.format_snapshot_time(nil, time_zone)
    assert formatted_time == nil
  end

  test ".format_snapshot_day" do
    time_zone = "America/New_York"
    datetime = ~U[2024-07-04 12:00:00Z]
    expected_formatted_day = "07/04"
    formatted_day = SnapshotConversions.format_snapshot_day(datetime, time_zone)
    assert formatted_day == expected_formatted_day

    formatted_day = SnapshotConversions.format_snapshot_day(nil, time_zone)
    assert formatted_day == nil
  end

  test ".icon_url" do
    weather_icon = "03d"
    expected_icon_url = "http://openweathermap.org/img/wn/#{weather_icon}.png"

    icon_url = SnapshotConversions.icon_url(weather_icon)
    assert icon_url == expected_icon_url
  end
end
