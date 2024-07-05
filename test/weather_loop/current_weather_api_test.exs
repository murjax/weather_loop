defmodule WeatherLoop.CurrentWeatherApiTest do
  use ExUnit.Case, async: true
  use WeatherLoop.RepoCase

  test ".get_current_weather_info" do
    city_name = "Jacksonville Beach"
    latitude = "30.2919324"
    longitude = "-81.4027473"
    city_attrs = %{name: city_name, state: "FL", latitude: latitude, longitude: longitude}
    {:ok, city} = WeatherLoop.Cities.create_city(city_attrs)

    current_weather_info = WeatherLoop.CurrentWeatherApi.get_current_weather_info(city)

    assert current_weather_info[:temperature] == 89.5
    assert current_weather_info[:feels_like] == 80.38
    assert current_weather_info[:humidity] == 89
    assert current_weather_info[:wind_speed] == 10.36
    assert current_weather_info[:wind_direction] == 150
    assert current_weather_info[:weather_title] == "Clouds"
    assert current_weather_info[:weather_description] == "broken clouds"
    assert current_weather_info[:weather_icon] == "04d"
    assert current_weather_info[:sunrise] == ~U[2022-07-01 10:27:17Z]
    assert current_weather_info[:sunset] == ~U[2022-07-02 00:31:21Z]
  end

  test ".get_current_weather_info failure" do
    city_name = "Green Cove Springs"
    latitude = "30.0425055"
    longitude = "-81.7312244"
    city_attrs = %{name: city_name, state: "FL", latitude: latitude, longitude: longitude}
    {:ok, city} = WeatherLoop.Cities.create_city(city_attrs)

    current_weather_info = WeatherLoop.CurrentWeatherApi.get_current_weather_info(city)

    assert current_weather_info == %{}
  end
end
