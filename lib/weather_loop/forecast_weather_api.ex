defmodule WeatherLoop.ForecastWeatherApi do
  @base_url Application.get_env(:weather_loop, :weather_api_base_url)

  alias WeatherLoop.Cities.City
  alias WeatherLoop.WeatherInfo

  def get_forecast_weather_info(city) do
    city
    |> perform_request
    |> parse_forecasts(city)
  end

  defp perform_request(city) do
    city
    |> get_coords
    |> url
    |> Tesla.get
    |> decode_response
  end

  defp parse_forecasts(forecasts, %City{} = city) do
    %{"list" => forecast_list} = forecasts

    Enum.map(forecast_list, fn weather_info -> parse_attributes(weather_info, city) end)
  end

  defp parse_attributes(weather_info, %City{} = city) do
    %{
      forecast: true,
      forecast_time: WeatherInfo.forecast_time(weather_info),
      temperature: WeatherInfo.temperature(weather_info),
      feels_like: WeatherInfo.feels_like(weather_info),
      humidity: WeatherInfo.humidity(weather_info),
      weather_title: WeatherInfo.weather_title(weather_info),
      weather_description: WeatherInfo.weather_description(weather_info),
      weather_icon: WeatherInfo.weather_icon(weather_info),
      city_id: city.id
    }
  end

  defp get_coords(%City{latitude: latitude, longitude: longitude}) do
    %{latitude: latitude, longitude: longitude}
  end

  defp url(%{latitude: latitude, longitude: longitude}) do
    @base_url <> "/data/2.5/forecast?lat=#{latitude}&lon=#{longitude}&units=imperial&appid=#{weather_api_key()}"
  end

  defp decode_response(response) do
    {:ok, %{body: body}} = response
    Jason.decode!(body)
  end

  defp weather_api_key do
    FigaroElixir.env["weather_api_key"]
  end
end
