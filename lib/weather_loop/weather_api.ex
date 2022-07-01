defmodule WeatherLoop.WeatherApi do
  @base_url Application.get_env(:weather_loop, :weather_api_base_url)

  def current_temperature(city_name) do
    city_name
    |> get_city_by_name
    |> get_temperature_by_city
  end

  defp get_temperature_by_city(%WeatherLoop.Cities.City{} = city) do
    city
    |> get_coords
    |> url
    |> Tesla.get
    |> decode_response
    |> get_temperature
  end

  defp get_temperature_by_city(nil), do: nil

  defp get_city_by_name(city_name) do
    WeatherLoop.Cities.get_city_by_name(city_name)
  end

  defp get_coords(%WeatherLoop.Cities.City{latitude: latitude, longitude: longitude}) do
    %{latitude: latitude, longitude: longitude}
  end

  defp url(%{latitude: latitude, longitude: longitude}) do
    @base_url <> "/data/2.5/weather?lat=#{latitude}&lon=#{longitude}&units=imperial&appid=#{weather_api_key()}"
  end

  defp decode_response(response) do
    {:ok, %{body: body}} = response
    Jason.decode!(body)
  end

  defp get_temperature(weather_info) do
    %{"main" => %{"temp" => temp}} = weather_info
    temp
  end

  defp weather_api_key do
    FigaroElixir.env["weather_api_key"]
  end
end
