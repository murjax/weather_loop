defmodule WeatherLoopWeb.CityController do
  use WeatherLoopWeb, :controller
  import Ecto.Query, only: [from: 2]
  alias WeatherLoop.WeatherSnapshots
  alias WeatherLoop.WeatherSnapshots.WeatherSnapshot
  alias WeatherLoop.Cities
  alias WeatherLoop.Cities.City

  def action(%Plug.Conn{assigns: %{current_user: current_user}} = conn, _opts) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, current_user])
  end

  def index(conn, _params, current_user) do
    city_query = from city in City, as: :city,
      left_join: snapshot in subquery(
        from snapshot in WeatherSnapshot,
        select: [:id, :city_id, :temperature, :weather_title],
        where: snapshot.forecast == false,
        order_by: [asc: :id]
      ), on: snapshot.city_id == city.id,
      distinct: city.id,
      select: %{id: city.id, name: city.name, state: city.state, temperature: snapshot.temperature, weather_title: snapshot.weather_title},
      where: city.user_id == ^current_user.id

    cities = WeatherLoop.Repo.all(city_query)

    render(conn, "index.html", cities: cities)
  end

  def new(conn, _params, _current_user) do
    changeset = City.changeset(%City{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"city" => city_params}, current_user) do
    city_params = Map.put(city_params, "user_id", current_user.id)
    case Cities.create_city(city_params) do
      {:ok, city} ->
        WeatherLoop.WeatherApi.capture_snapshots(city)

        conn
        |> put_flash(:info, "City created successfully.")
        |> redirect(to: Routes.city_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}, _current_user) do
    city = Cities.get_city!(id)
    changeset = City.changeset(city)
    render(conn, "edit.html", city: city, changeset: changeset)
  end

  def update(conn, %{"id" => id, "city" => city_params}, current_user) do
    city = Cities.get_city!(id)

    case Cities.update_city(city, city_params) do
      {:ok, city} ->
        WeatherLoop.WeatherApi.capture_snapshots(city)

        conn
        |> put_flash(:info, "City updated successfully.")
        |> redirect(to: Routes.city_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user) do
    city = Cities.get_city!(id)

    WeatherSnapshots.delete_snapshots_for_city_id(id)

    {:ok, _city} = Cities.delete_city(city)

    conn
    |> put_flash(:info, "City deleted successfully.")
    |> redirect(to: Routes.city_path(conn, :index))
  end
end
