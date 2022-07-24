defmodule WeatherLoopWeb.CityController do
  use WeatherLoopWeb, :controller
  import Ecto.Query, only: [from: 2]
  alias WeatherLoop.WeatherSnapshots.WeatherSnapshot
  alias WeatherLoop.Cities.City
  alias WeatherLoop.WeatherSnapshots
  alias WeatherLoop.Cities

  def index(conn, _params) do
    city_query = from city in City, as: :city,
      left_join: snapshot in subquery(
        from snapshot in WeatherSnapshot,
        select: [:id, :city_id, :temperature, :weather_title],
        where: snapshot.forecast == false,
        order_by: [asc: :id]
      ), on: snapshot.city_id == city.id,
      distinct: city.id,
      select: %{id: city.id, name: city.name, state: city.state, temperature: snapshot.temperature, weather_title: snapshot.weather_title}

    cities = WeatherLoop.Repo.all(city_query)

    render(conn, "index.html", cities: cities)
  end

  def show(conn, %{"id" => id}) do
    city = Cities.get_city!(id)
    current_weather_snapshot = WeatherSnapshots.get_current_weather_snapshot_for_city_id(id)
    forecasts_start_at = DateTime.now!("Etc/UTC") |> DateTime.to_unix
    forecast_snapshots = WeatherSnapshots.get_forecast_snapshots_for_city_id(id, forecasts_start_at, 4)
    all_forecast_snapshots = WeatherSnapshots.get_forecast_snapshots_for_city_id(id, forecasts_start_at)
    day_forecasts = WeatherSnapshots.get_day_forecasts(all_forecast_snapshots)

    current_time_response = Calendar.DateTime.now("America/New_York")
    {:ok, current_time} = current_time_response
    formatted_date_response = Calendar.Strftime.strftime(current_time, "%b %d %Y")
    {:ok, formatted_date} = formatted_date_response

    render(conn,
      "show.html",
      city: city,
      current_weather_snapshot: current_weather_snapshot,
      forecast_snapshots: forecast_snapshots,
      day_forecasts: day_forecasts,
      formatted_date: formatted_date
    )
  end
end
