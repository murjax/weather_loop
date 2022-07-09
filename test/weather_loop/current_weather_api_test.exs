defmodule WeatherLoop.CurrentWeatherApiTest do
  use ExUnit.Case, async: true
  use WeatherLoop.RepoCase

  @city_name "Jacksonville Beach"

  setup _context do
    latitude = "30.2919324"
    longitude = "-81.4027473"
    city_attrs = %{name: @city_name, state: "FL", latitude: latitude, longitude: longitude}
    {:ok, city} = WeatherLoop.Cities.create_city(city_attrs)
    {:ok, city: city}
  end

  test ".get_current_weather_info", context do
    current_weather_info = WeatherLoop.CurrentWeatherApi.get_current_weather_info(context[:city])

    assert current_weather_info[:temperature] == 89.5
    assert current_weather_info[:feels_like] == 80.38
    assert current_weather_info[:humidity] == 89
    assert current_weather_info[:wind_speed] == 10.36
    assert current_weather_info[:wind_direction] == 150
    assert current_weather_info[:weather_title] == "Clouds"
    assert current_weather_info[:weather_description] == "broken clouds"
    assert current_weather_info[:weather_icon] == "04d"
    assert current_weather_info[:sunrise] == 1656671237
    assert current_weather_info[:sunset] == 1656721881
  end
end
