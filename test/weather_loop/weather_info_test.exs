defmodule WeatherLoop.WeatherInfoTest do
  use ExUnit.Case, async: true

  @weather_info %{
    "base" => "stations",
    "clouds" => %{"all" => 75},
    "cod" => 200,
    "coord" => %{"lat" => 30.29, "lon" => -81.4},
    "dt" => 1656711307,
    "id" => 4160023,
    "main" => %{
      "feels_like" => 80.38,
      "humidity" => 89,
      "pressure" => 1017,
      "temp" => 89.5,
      "temp_max" => 86.22,
      "temp_min" => 75.18
    },
    "name" => "Jacksonville Beach",
    "sys" => %{
      "country" => "US",
      "id" => 5111,
      "sunrise" => 1656671237,
      "sunset" => 1656721881,
      "type" => 1
    },
    "timezone" => -14400,
    "visibility" => 10000,
    "weather" => [
      %{
        "description" => "broken clouds",
        "icon" => "04d",
        "id" => 803,
        "main" => "Clouds"
      }
    ],
    "wind" => %{"deg" => 150, "speed" => 10.36}
  }

  test ".forecast_time" do
    expected_forecast_time = 1656711307
    forecast_time = WeatherLoop.WeatherInfo.forecast_time(@weather_info)
    assert forecast_time == expected_forecast_time
  end

  test ".temperature" do
    expected_temperature = 89.5
    temperature = WeatherLoop.WeatherInfo.temperature(@weather_info)
    assert temperature == expected_temperature
  end

  test ".feels_like" do
    expected_feels_like = 80.38
    feels_like = WeatherLoop.WeatherInfo.feels_like(@weather_info)
    assert feels_like == expected_feels_like
  end

  test ".humidity" do
    expected_humidity = 89
    humidity = WeatherLoop.WeatherInfo.humidity(@weather_info)
    assert humidity == expected_humidity
  end

  test ".visibility" do
    expected_visibility = 10000
    visibility = WeatherLoop.WeatherInfo.visibility(@weather_info)
    assert visibility == expected_visibility
  end

  test ".wind_speed" do
    expected_wind_speed = 10.36
    wind_speed = WeatherLoop.WeatherInfo.wind_speed(@weather_info)
    assert wind_speed == expected_wind_speed
  end

  test ".wind_direction" do
    expected_wind_direction = 150
    wind_direction = WeatherLoop.WeatherInfo.wind_direction(@weather_info)
    assert wind_direction == expected_wind_direction
  end

  test ".weather_title" do
    expected_weather_title = "Clouds"
    weather_title = WeatherLoop.WeatherInfo.weather_title(@weather_info)
    assert weather_title == expected_weather_title
  end

  test ".weather_description" do
    expected_weather_description = "broken clouds"
    weather_description = WeatherLoop.WeatherInfo.weather_description(@weather_info)
    assert weather_description == expected_weather_description
  end

  test ".weather_icon" do
    expected_weather_icon = "04d"
    weather_icon = WeatherLoop.WeatherInfo.weather_icon(@weather_info)
    assert weather_icon == expected_weather_icon
  end

  test ".sunrise" do
    expected_sunrise = 1656671237
    sunrise = WeatherLoop.WeatherInfo.sunrise(@weather_info)
    assert sunrise == expected_sunrise
  end

  test ".sunset" do
    expected_sunset = 1656721881
    sunset = WeatherLoop.WeatherInfo.sunset(@weather_info)
    assert sunset == expected_sunset
  end
end
