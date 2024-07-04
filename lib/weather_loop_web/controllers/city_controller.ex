defmodule WeatherLoopWeb.CityController do
  use WeatherLoopWeb, :controller
  import Ecto.Query, only: [from: 2]
  alias WeatherLoop.WeatherSnapshots
  alias WeatherLoop.WeatherSnapshots.WeatherSnapshot
  alias WeatherLoop.Cities
  alias WeatherLoop.Cities.City

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

    render(conn, "index.html", cities: cities)
  end

  def new(conn, _params) do
    changeset = City.changeset(%City{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"city" => city_params}) do
    city_params = Map.put(city_params, "user_id", conn.assigns.current_user.id)
    city_params = Cities.upload_file(city_params["background_image"])
                  |> Cities.add_url_to_params("background_image_url", city_params)
    city_params = Cities.upload_file(city_params["audio_file"])
                  |> Cities.add_url_to_params("audio_url", city_params)
    case Cities.create_city(city_params) do
      {:ok, city} ->
        Cities.capture_time_zone(city)
        WeatherLoop.WeatherApi.capture_snapshots(city)

        conn
        |> put_flash(:info, "City created successfully.")
        |> redirect(to: Routes.city_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    city = Cities.get_city!(id)
    changeset = City.changeset(city)
    render(conn, "edit.html", city: city, changeset: changeset)
  end

  def update(conn, %{"id" => id, "city" => city_params}) do
    city = Cities.get_city!(id)

    city_params = Cities.upload_file(city, city_params["background_image"])
                  |> Cities.add_url_to_params("background_image_url", city_params)
    city_params = Cities.upload_file(city, city_params["audio_file"])
                  |> Cities.add_url_to_params("audio_url", city_params)

    case Cities.update_city(city, city_params) do
      {:ok, city} ->
        Cities.capture_time_zone(city)
        WeatherLoop.WeatherApi.capture_snapshots(city)

        conn
        |> put_flash(:info, "City updated successfully.")
        |> redirect(to: Routes.city_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    city = Cities.get_city!(id)

    WeatherSnapshots.delete_snapshots_for_city_id(id)

    {:ok, _city} = Cities.delete_city(city)

    conn
    |> put_flash(:info, "City deleted successfully.")
    |> redirect(to: Routes.city_path(conn, :index))
  end
end
