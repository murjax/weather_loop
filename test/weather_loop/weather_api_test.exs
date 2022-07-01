defmodule WeatherLoop.WeatherApiTest do
  use ExUnit.Case, async: true
  use WeatherLoop.RepoCase

  @city_name "Jacksonville Beach"

  setup _context do
    latitude = "30.2919324"
    longitude = "-81.4027473"
    city_attrs = %{name: @city_name, latitude: latitude, longitude: longitude}
    {:ok, city} = WeatherLoop.Cities.create_city(city_attrs)
    {:ok, city: city}
  end

  test ".capture_snapshot", context do
    snapshot = WeatherLoop.WeatherApi.capture_snapshot(context[:city])
    assert snapshot.temperature == 89.5
    assert snapshot.feels_like == 80.38
    assert snapshot.humidity == 89
    assert snapshot.wind_speed == 10.36
    assert snapshot.wind_direction == 150
    assert snapshot.weather_title == "Clouds"
    assert snapshot.weather_description == "broken clouds"
    assert snapshot.weather_icon == "04d"
    assert snapshot.sunrise == 1656671237
    assert snapshot.sunset == 1656721881

    snapshot = WeatherLoop.WeatherApi.capture_snapshot(nil)
    assert snapshot == nil
  end
end
