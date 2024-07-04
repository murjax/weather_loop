defmodule WeatherLoop.CurrentWeatherApi do
  alias WeatherLoop.Cities.City
  alias WeatherLoop.WeatherInfo

  def get_current_weather_info(city) do
    city
    |> url()
    |> Tesla.get()
    |> decode_response()
    |> parse_attributes(city)
  end

  defp parse_attributes(weather_info, %City{} = city) do
    %{}
    |> Map.put(:temperature, WeatherInfo.temperature(weather_info))
    |> Map.put(:feels_like, WeatherInfo.feels_like(weather_info))
    |> Map.put(:humidity, WeatherInfo.humidity(weather_info))
    |> Map.put(:visibility, WeatherInfo.visibility(weather_info))
    |> Map.put(:wind_speed, WeatherInfo.wind_speed(weather_info))
    |> Map.put(:wind_direction, WeatherInfo.wind_direction(weather_info))
    |> Map.put(:weather_title, WeatherInfo.weather_title(weather_info))
    |> Map.put(:weather_description, WeatherInfo.weather_description(weather_info))
    |> Map.put(:weather_icon, WeatherInfo.weather_icon(weather_info))
    |> Map.put(:sunrise, WeatherInfo.sunrise(weather_info) |> Calendar.DateTime.Parse.unix!())
    |> Map.put(:sunset, WeatherInfo.sunset(weather_info) |> Calendar.DateTime.Parse.unix!())
    |> Map.put(:city_id, city.id)
  end

  defp url(%City{latitude: latitude, longitude: longitude}) do
    base_url = Application.get_env(:weather_loop, WeatherApi)[:weather_api_base_url]
    api_key = Application.get_env(:weather_loop, WeatherApi)[:weather_api_key]
    base_url <> "/data/2.5/weather?lat=#{latitude}&lon=#{longitude}&units=imperial&appid=#{api_key}"
  end

  defp decode_response(response) do
    {:ok, %{body: body}} = response
    Jason.decode!(body)
  end
end
