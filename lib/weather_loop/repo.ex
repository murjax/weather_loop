defmodule WeatherLoop.Repo do
  use Ecto.Repo,
    otp_app: :weather_loop,
    adapter: Ecto.Adapters.Postgres
end
