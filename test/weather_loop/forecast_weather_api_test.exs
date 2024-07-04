defmodule WeatherLoop.ForecastWeatherApiTest do
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

  test ".get_forecast_weather_info", context do
    forecast_weather_info = WeatherLoop.ForecastWeatherApi.get_forecast_weather_info(context[:city])
    weather_info = List.first(forecast_weather_info)

    assert weather_info[:forecast_time] == ~U[2022-07-01 21:35:07Z]
    assert weather_info[:forecast] == true
    assert weather_info[:temperature] == 89.5
    assert weather_info[:feels_like] == 80.38
    assert weather_info[:humidity] == 89
    assert weather_info[:weather_title] == "Clouds"
    assert weather_info[:weather_description] == "broken clouds"
    assert weather_info[:weather_icon] == "04d"
  end
end
