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

  def delete_city(%City{} = city) do
    city
    |> Repo.delete()
  end

  def upload_background_image(_, nil), do: nil
  def upload_background_image(city, upload) do
    extension = Path.extname(upload.filename)
    timestamp = Calendar.DateTime.now_utc
                |> Calendar.DateTime.Format.unix
                |> to_string
    filename = "#{timestamp}-#{city.id}#{extension}"
    store_path = "media/#{filename}"
    get_path = "/uploads/#{filename}"
    File.cp(upload.path, store_path)
    get_path
  end
  def upload_background_image(nil), do: nil
  def upload_background_image(upload) do
    extension = Path.extname(upload.filename)
    timestamp = Calendar.DateTime.now_utc
                |> Calendar.DateTime.Format.unix
                |> to_string
    filename = "#{timestamp}#{extension}"
    store_path = "media/#{filename}"
    get_path = "/uploads/#{filename}"
    File.cp(upload.path, store_path)
    get_path
  end

  def add_background_image_url_to_params(nil, params), do: params
  def add_background_image_url_to_params(background_image_url, params) do
    Map.put(params, "background_image_url", background_image_url)
  end
end
