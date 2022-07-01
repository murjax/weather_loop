defmodule WeatherLoop.WeatherApi do
  @base_url Application.get_env(:weather_loop, :weather_api_base_url)

  alias WeatherLoop.Cities.City

  def temperature(%City{} = city) do
    city
    |> get_weather_info
    |> get_temperature
  end

  def temperature(nil), do: nil

  def feels_like(%City{} = city) do
    city
    |> get_weather_info
    |> get_feels_like
  end

  def feels_like(nil), do: nil

  def humidity(%City{} = city) do
    city
    |> get_weather_info
    |> get_humidity
  end

  def humidity(nil), do: nil

  def visibility(%City{} = city) do
    city
    |> get_weather_info
    |> get_visibility
  end

  def visibility(nil), do: nil

  def wind_speed(%City{} = city) do
    city
    |> get_weather_info
    |> get_wind_speed
  end

  def wind_speed(nil), do: nil

  def wind_direction(%City{} = city) do
    city
    |> get_weather_info
    |> get_wind_direction
  end

  def wind_direction(nil), do: nil

  def weather_title(%City{} = city) do
    city
    |> get_weather_info
    |> get_weather_title
  end

  def weather_title(nil), do: nil

  def weather_description(%City{} = city) do
    city
    |> get_weather_info
    |> get_weather_description
  end

  def weather_description(nil), do: nil

  def weather_icon(%City{} = city) do
    city
    |> get_weather_info
    |> get_weather_icon
  end

  def weather_icon(nil), do: nil

  def sunrise(%City{} = city) do
    city
    |> get_weather_info
    |> get_sunrise
  end

  def sunrise(nil), do: nil

  def sunset(%City{} = city) do
    city
    |> get_weather_info
    |> get_sunset
  end

  def sunset(nil), do: nil

  defp get_weather_info(city) do
    city
    |> get_coords
    |> url
    |> Tesla.get
    |> decode_response
  end

  defp get_coords(%City{latitude: latitude, longitude: longitude}) do
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

  defp get_feels_like(weather_info) do
    %{"main" => %{"feels_like" => feels_like}} = weather_info
    feels_like
  end

  defp get_humidity(weather_info) do
    %{"main" => %{"humidity" => humidity}} = weather_info
    humidity
  end

  defp get_visibility(weather_info) do
    %{"visibility" => visibility} = weather_info
    visibility
  end

  defp get_wind_speed(weather_info) do
    %{"wind" => %{"speed" => wind_speed}} = weather_info
    wind_speed
  end

  defp get_wind_direction(weather_info) do
    %{"wind" => %{"deg" => wind_direction}} = weather_info
    wind_direction
  end

  defp get_weather_title(weather_info) do
    %{"weather" => [%{"main" => weather_title}]} = weather_info
    weather_title
  end

  defp get_weather_description(weather_info) do
    %{"weather" => [%{"description" => weather_description}]} = weather_info
    weather_description
  end

  defp get_weather_icon(weather_info) do
    %{"weather" => [%{"icon" => weather_icon}]} = weather_info
    weather_icon
  end

  defp get_sunrise(weather_info) do
    %{"sys" => %{"sunrise" => sunrise}} = weather_info
    sunrise
  end

  defp get_sunset(weather_info) do
    %{"sys" => %{"sunset" => sunset}} = weather_info
    sunset
  end

  defp weather_api_key do
    FigaroElixir.env["weather_api_key"]
  end
end
