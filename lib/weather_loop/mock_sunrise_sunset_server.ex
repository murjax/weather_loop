defmodule WeatherLoop.MockSunriseSunsetServer do
  use Plug.Router

  plug Plug.Parsers, parsers: [:json],
                    pass:  ["text/*"],
                    json_decoder: Jason

  plug :match
  plug :dispatch

  get "/json/*query_params" do
    process_response(conn)
  end

  defp process_response(%{query_params: %{"lat" => "30.0425055", "lng" => "-81.7312244"}} = conn) do
    failure(conn, failure_response())
  end

  defp process_response(%{query_params: %{"date" => "2024-07-01"}} = conn) do
    success(conn, sample_date_specific_response())
  end

  defp process_response(conn) do
    success(conn, sample_response())
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
    %{"status" => "ERROR"}
  end

  defp sample_response do
    %{
      results: %{
        "date" => "2024-07-04",
        "sunrise" => "5:49:21 AM",
        "sunset" => "8:38:08 PM",
        "first_light" => "3:52:08 AM",
        "last_light" => "10:35:21 PM",
        "dawn" => "5:17:35 AM",
        "dusk" => "9:09:54 PM",
        "solar_noon" => "1:13:45 PM",
        "golden_hour" => "7:58:29 PM",
        "day_length" => "14:48:46",
        "timezone" => "America/New_York",
        "utc_offset" => -240
      },
      status: "OK"
    }
  end

  defp sample_date_specific_response do
    %{
      results: %{
        "date" => "2024-07-01",
        "sunrise" => "5:49:21 AM",
        "sunset" => "8:38:08 PM",
        "first_light" => "3:52:08 AM",
        "last_light" => "10:35:21 PM",
        "dawn" => "5:17:35 AM",
        "dusk" => "9:09:54 PM",
        "solar_noon" => "1:13:45 PM",
        "golden_hour" => "7:58:29 PM",
        "day_length" => "14:48:46",
        "timezone" => "America/New_York",
        "utc_offset" => -240
      },
      status: "OK"
    }
  end
end
