defmodule WeatherLoop.WeatherInfo do
  def forecast_time(weather_info) do
    %{"dt" => time} = weather_info
    time
  end

  def temperature(weather_info) do
    %{"main" => %{"temp" => temp}} = weather_info
    temp
  end

  def feels_like(weather_info) do
    %{"main" => %{"feels_like" => feels_like}} = weather_info
    feels_like
  end

  def humidity(weather_info) do
    %{"main" => %{"humidity" => humidity}} = weather_info
    humidity
  end

  def visibility(weather_info) do
    %{"visibility" => visibility} = weather_info
    visibility
  end

  def wind_speed(weather_info) do
    %{"wind" => %{"speed" => wind_speed}} = weather_info
    wind_speed
  end

  def wind_direction(weather_info) do
    %{"wind" => %{"deg" => wind_direction}} = weather_info
    wind_direction
  end

  def weather_title(weather_info) do
    %{"weather" => [%{"main" => weather_title}]} = weather_info
    weather_title
  end

  def weather_description(weather_info) do
    %{"weather" => [%{"description" => weather_description}]} = weather_info
    weather_description
  end

  def weather_icon(weather_info) do
    %{"weather" => [%{"icon" => weather_icon}]} = weather_info
    weather_icon
  end

  def sunrise(weather_info) do
    %{"sys" => %{"sunrise" => sunrise}} = weather_info
    sunrise
  end

  def sunset(weather_info) do
    %{"sys" => %{"sunset" => sunset}} = weather_info
    sunset
  end
end
