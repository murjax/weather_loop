defmodule WeatherLoop.WeatherApiTest do
  use ExUnit.Case, async: true

  test "returning current temperature for location" do
    lat = "30.2919324"
    lon = "-81.4027473"
    coords = %{lat: lat, lon: lon}
    expected_temperature = 89.5

    current_temperature = WeatherLoop.WeatherApi.current_temperature(coords)
    assert current_temperature == expected_temperature
  end
end
