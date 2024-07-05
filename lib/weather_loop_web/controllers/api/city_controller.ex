defmodule WeatherLoopWeb.Api.CityController do
  use WeatherLoopWeb, :controller
  import Ecto.Query

  alias WeatherLoop.Cities
  alias WeatherLoop.Cities.City
  alias WeatherLoop.WeatherSnapshots
  alias WeatherLoop.WeatherSnapshots.WeatherSnapshot

  def index(conn, _params) do
    city_query = from city in City, as: :city,
      left_join: snapshot in subquery(
        from snapshot in WeatherSnapshot,
        select: [:id, :city_id, :temperature, :weather_title],
        where: snapshot.forecast == false,
        order_by: [asc: :id]
      ), on: snapshot.city_id == city.id,
      distinct: city.id,
      select: %{id: city.id, name: city.name, state: city.state, temperature: snapshot.temperature, weather_title: snapshot.weather_title},
      where: city.user_id == ^conn.assigns.current_user.id

    cities = WeatherLoop.Repo.all(city_query)

    conn
    |> put_status(:ok)
    |> render("index.json", cities: cities)
  end

  def show(conn, %{"id" => id}) do
    city = Cities.get_city!(id)
    collection = WeatherSnapshots.get_decorated_snapshot_collection_for_city_id(id)
    response = %{
      city: city,
      current_weather: collection[:current_weather_snapshot],
      hourly_forecasts: collection[:forecast_snapshots],
      day_forecasts: collection[:day_forecasts]
    }

    conn
    |> put_status(:ok)
    |> render("show.json", %{response: response})
  end
end
