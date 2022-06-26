defmodule WeatherLoop.MockServer do
  use Plug.Router

  plug Plug.Parsers, parsers: [:json],
                    pass:  ["text/*"],
                    json_decoder: Jason

  plug :match
  plug :dispatch

  get "/data/2.5/weather/*query_params" do
    temp = 89.5
    response_body = %{"main" => %{"temp" => temp}}
    success(conn, response_body)
  end

  defp success(conn, body) do
    conn
    |> Plug.Conn.send_resp(200, Jason.encode!(body))
  end
end
