defmodule WeatherLoop.SunriseSunsetApiTest do
  use ExUnit.Case, async: true
  use WeatherLoop.RepoCase

  test ".get_data" do
    latitude = "30.2919324"
    longitude = "-81.4027473"

    data = WeatherLoop.SunriseSunsetApi.get_data(latitude, longitude)

    assert data[:date] == "2024-07-04"
    assert DateTime.to_string(data[:sunrise]) == "2024-07-04 09:49:21+00:00 UTC UTC"
    assert DateTime.to_string(data[:sunset]) == "2024-07-05 00:38:08+00:00 UTC UTC"
    assert DateTime.to_string(data[:first_light]) == "2024-07-04 07:52:08+00:00 UTC UTC"
    assert DateTime.to_string(data[:last_light]) == "2024-07-05 02:35:21+00:00 UTC UTC"
    assert DateTime.to_string(data[:dawn]) == "2024-07-04 09:17:35+00:00 UTC UTC"
    assert DateTime.to_string(data[:dusk]) == "2024-07-05 01:09:54+00:00 UTC UTC"
    assert DateTime.to_string(data[:solar_noon]) == "2024-07-04 17:13:45+00:00 UTC UTC"
    assert DateTime.to_string(data[:golden_hour]) == "2024-07-04 23:58:29+00:00 UTC UTC"
    assert data[:day_length] == "14:48:46"
    assert data[:timezone] == "America/New_York"
    assert data[:utc_offset] == -240
  end
end
