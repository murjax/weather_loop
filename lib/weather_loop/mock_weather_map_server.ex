defmodule WeatherLoop.MockWeatherMapServer do
  use Plug.Router

  plug Plug.Parsers, parsers: [:json],
                    pass:  ["text/*"],
                    json_decoder: Jason

  plug :match
  plug :dispatch

  get "/data/2.5/weather/*query_params" do
    process_current_response(conn)
  end

  get "/data/2.5/forecast/*query_params" do
    process_forecast_response(conn)
  end

  defp process_current_response(%{query_params: %{"lat" => "30.0425055", "lon" => "-81.7312244"}} = conn) do
    failure(conn, failure_response())
  end

  defp process_current_response(conn) do
    success(conn, sample_current_weather())
  end

  defp process_forecast_response(%{query_params: %{"lat" => "30.0425055", "lon" => "-81.7312244"}} = conn) do
    failure(conn, failure_response())
  end

  defp process_forecast_response(conn) do
    success(conn, sample_forecast_weather())
  end

  defp success(conn, body) do
    conn
    |> Plug.Conn.send_resp(200, Jason.encode!(body))
  end

  defp failure(conn, body) do
    conn
    |> Plug.Conn.send_resp(400, Jason.encode!(body))
  end

  defp failure_response do
    %{
      "cod" => "400",
      "message" => "Nothing to geocode"
    }
  end

  defp sample_current_weather do
    %{
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
  end

  defp sample_forecast_weather do
    %{
      "list" => [
        %{
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
      ]
    }
  end
end
