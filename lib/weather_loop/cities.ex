defmodule WeatherLoop.Cities do
  @moduledoc """
  The City context.
  """

  import Ecto.Query, warn: false
  alias WeatherLoop.Repo

  alias WeatherLoop.Cities.City

  @doc """
  Returns the list of cities.

  ## Examples

      iex> list_cities()
      [%City{}, ...]

  """
  def list_cities do
    Repo.all(City)
  end

  def get_city_by_name(name) do
    Repo.get_by(City, name: name)
  end

  def get_city!(id), do: Repo.get!(City, id)

  def create_city(attrs \\ %{}) do
    %City{}
    |> City.changeset(attrs)
    |> Repo.insert()
  end

  def update_city(%City{} = city, attrs) do
    city
    |> City.changeset(attrs)
    |> Repo.update()
  end
end
