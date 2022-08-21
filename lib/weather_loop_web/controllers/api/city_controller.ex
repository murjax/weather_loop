defmodule WeatherLoopWeb.Api.CityController do
  use WeatherLoopWeb, :controller
  alias WeatherLoop.WeatherSnapshots
  alias WeatherLoop.Cities

  def show(conn, %{"id" => id}) do
    city = Cities.get_city!(id)
    decorated_snapshot_collection = WeatherSnapshots.get_decorated_snapshot_collection_for_city_id(id)

    json(conn, %{city: city, snapshots: decorated_snapshot_collection})
  end
end
