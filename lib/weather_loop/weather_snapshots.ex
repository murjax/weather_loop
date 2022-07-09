defmodule WeatherLoop.WeatherSnapshots do
  @moduledoc """
  The WeatherSnapshot context.
  """

  import Ecto.Query, warn: false
  alias WeatherLoop.Repo

  alias WeatherLoop.WeatherSnapshots.WeatherSnapshot

  @doc """
  Returns the list of weather snapshots.

  ## Examples

      iex> list_weather_snapshots()
      [%WeatherSnapshot{}, ...]

  """
  def list_weather_snapshots do
    Repo.all(WeatherSnapshot)
  end

  def get_current_weather_snapshot_for_city_id(city_id) do
    query = from snapshot in WeatherSnapshot,
      where: [city_id: ^city_id],
      where: snapshot.forecast == false,
      order_by: [desc: :id],
      limit: 1

    Repo.all(query) |> List.first
  end

  def get_forecast_snapshots_for_city_id(city_id, starting_at) do
    query = from snapshot in WeatherSnapshot,
      where: [city_id: ^city_id],
      where: snapshot.forecast == true,
      order_by: [asc: :id]

    Repo.all(query)
  end

  def create_weather_snapshot(attrs \\ %{}) do
    %WeatherSnapshot{}
    |> WeatherSnapshot.changeset(attrs)
    |> Repo.insert()
  end
end
