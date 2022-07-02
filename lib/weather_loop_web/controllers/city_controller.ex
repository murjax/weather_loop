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
        from WeatherSnapshot,
        select: [:id, :city_id, :temperature, :weather_title],
        order_by: [desc: :id]
      ), on: snapshot.city_id == city.id,
      select: %{name: city.name, temperature: snapshot.temperature, weather_title: snapshot.weather_title}

    cities = WeatherLoop.Repo.all(city_query)

    render(conn, "index.html", cities: cities)
  end

  def show(conn, %{"id" => id}) do
    city = Cities.get_city!(id)
    snapshot = WeatherSnapshots.get_latest_snapshot_for_city_id(id)
    current_time_response = Calendar.DateTime.now("America/New_York")
    {:ok, current_time} = current_time_response
    formatted_time_response = Calendar.Strftime.strftime(current_time, "%b %d %Y - %I:%M:%S%P")
    {:ok, formatted_time} = formatted_time_response



    render(conn, "show.html", city: city, snapshot: snapshot, formatted_time: formatted_time)
  end
end
