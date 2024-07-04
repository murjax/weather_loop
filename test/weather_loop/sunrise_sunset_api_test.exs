defmodule WeatherLoop.SunriseSunsetApiTest do
  use ExUnit.Case, async: true
  use WeatherLoop.RepoCase

  test ".get_data" do
    latitude = "30.2919324"
    longitude = "-81.4027473"

    data = WeatherLoop.SunriseSunsetApi.get_data(latitude, longitude)

    assert data[:date] == "2024-07-04"
    assert data[:sunrise] == 1720072161
    assert data[:sunset] == 1720125488
    assert data[:first_light] == 1720065128
    assert data[:last_light] == 1720132521
    assert data[:dawn] == 1720070255
    assert data[:dusk] == 1720127394
    assert data[:solar_noon] == 1720098825
    assert data[:golden_hour] == 1720123109
    assert data[:day_length] == "14:48:46"
    assert data[:timezone] == "America/New_York"
    assert data[:utc_offset] == -240
  end
end
