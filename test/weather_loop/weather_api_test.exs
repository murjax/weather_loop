defmodule WeatherLoop.WeatherApiTest do
  use ExUnit.Case, async: true
  use WeatherLoop.RepoCase

  @city_name "Jacksonville Beach"

  setup _context do
    latitude = "30.2919324"
    longitude = "-81.4027473"
    city_attrs = %{name: @city_name, latitude: latitude, longitude: longitude}
    {:ok, city} = WeatherLoop.Cities.create_city(city_attrs)
    {:ok, city: city}
  end
end
