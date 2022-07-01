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

  def create_weather_snapshot(attrs \\ %{}) do
    %WeatherSnapshot{}
    |> WeatherSnapshot.changeset(attrs)
    |> Repo.insert()
  end
end
