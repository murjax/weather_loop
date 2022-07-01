defmodule WeatherLoop.WeatherApiTest do
  use ExUnit.Case, async: true
  use WeatherLoop.RepoCase

  test "returning current temperature for city" do
    latitude = "30.2919324"
    longitude = "-81.4027473"
    name = "Jacksonville Beach"
    city_attrs = %{name: name, latitude: latitude, longitude: longitude}
    WeatherLoop.Cities.create_city(city_attrs)

    expected_temperature = 89.5

    current_temperature = WeatherLoop.WeatherApi.current_temperature(name)
    assert current_temperature == expected_temperature
  end

  test "returning nil for unavailable city" do
    name = "Raleigh"
    current_temperature = WeatherLoop.WeatherApi.current_temperature(name)
    assert current_temperature == nil
  end
end
