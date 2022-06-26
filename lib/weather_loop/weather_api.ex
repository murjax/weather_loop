defmodule WeatherLoop.WeatherApi do
  def current_temperature(coords) do
    coords
    |> url
    |> Tesla.get
    |> decode_response
    |> get_temperature
  end

  defp url(%{lat: lat, lon: lon}) do
    "https://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lon}&units=imperial&appid=#{FigaroElixir.env["weather_api_key"]}"
  end

  defp decode_response(response) do
    {:ok, %{body: body}} = response
    Jason.decode!(body)
  end

  defp get_temperature(weather_info) do
    %{"main" => %{"temp" => temp}} = weather_info
    temp
  end
end
