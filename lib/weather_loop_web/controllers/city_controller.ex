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
    collection = WeatherSnapshots.get_decorated_snapshot_collection_for_city_id(id)

    render(
      conn,
      "show.html",
      city: city,
      current_weather_snapshot: collection[:current_weather_snapshot],
      forecast_snapshots: collection[:forecast_snapshots],
      day_forecasts: collection[:day_forecasts]
    )
  end
end
