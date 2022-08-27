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

  def get_weather_snapshot!(id), do: Repo.get!(WeatherSnapshot, id)

  def get_weather_snapshot(id), do: Repo.get(WeatherSnapshot, id)

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
      where: snapshot.forecast_time >= ^starting_at,
      order_by: [asc: :id]

    Repo.all(query)
  end

  def get_forecast_snapshots_for_city_id(city_id, starting_at, limit) do
    query = from snapshot in WeatherSnapshot,
      where: [city_id: ^city_id],
      where: snapshot.forecast == true,
      where: snapshot.forecast_time >= ^starting_at,
      order_by: [asc: :id],
      limit: ^limit

    Repo.all(query)
  end

  def get_decorated_snapshot_collection_for_city_id(city_id) do
    snapshot_collection = get_snapshot_collection_for_city_id(city_id)

    %{
      current_weather_snapshot: WeatherLoop.WeatherSnapshots.Decorator.decorate(snapshot_collection[:current_weather_snapshot]),
      forecast_snapshots: WeatherLoop.WeatherSnapshots.Decorator.decorate_collection(snapshot_collection[:forecast_snapshots]),
      day_forecasts: WeatherLoop.DayForecasts.Decorator.decorate_collection(snapshot_collection[:day_forecasts])
    }
  end

  def get_snapshot_collection_for_city_id(city_id) do
    current_weather_snapshot = get_current_weather_snapshot_for_city_id(city_id)
    forecasts_start_at = DateTime.now!("Etc/UTC") |> DateTime.to_unix
    forecast_snapshots = get_forecast_snapshots_for_city_id(city_id, forecasts_start_at, 4)
    all_forecast_snapshots = get_forecast_snapshots_for_city_id(city_id, forecasts_start_at)
    day_forecasts = get_day_forecasts(all_forecast_snapshots)

    %{
      current_weather_snapshot: current_weather_snapshot,
      forecast_snapshots: forecast_snapshots,
      day_forecasts: day_forecasts
    }
  end

  def create_weather_snapshot(attrs \\ %{}) do
    %WeatherSnapshot{}
    |> WeatherSnapshot.changeset(attrs)
    |> Repo.insert()
  end

  def delete_snapshots_for_city_id(city_id) do
    from(snapshot in WeatherSnapshot, where: [city_id: ^city_id])
    |> Repo.delete_all
  end

  defp get_day_forecasts(snapshots) do
    forecast_times = WeatherLoop.DayForecasts.ForecastTimes.calculate
    day_one = forecast_times[:day_one]
    day_two = forecast_times[:day_two]
    day_three = forecast_times[:day_three]

    day_one_snapshots = snapshots_for_day(snapshots, day_one[:start_of_day], day_one[:end_of_day])
    day_two_snapshots = snapshots_for_day(snapshots, day_two[:start_of_day], day_two[:end_of_day])
    day_three_snapshots = snapshots_for_day(snapshots, day_three[:start_of_day], day_three[:end_of_day])

    day_one_forecast = get_day_forecast(day_one_snapshots, day_one[:start_of_day])
    day_two_forecast = get_day_forecast(day_two_snapshots, day_two[:start_of_day])
    day_three_forecast = get_day_forecast(day_three_snapshots, day_three[:start_of_day])

    [day_one_forecast, day_two_forecast, day_three_forecast]
  end

  defp get_day_forecast(snapshots, day_epoch) do
    temperatures = Enum.map(snapshots, fn snapshot -> snapshot.temperature end)
    low_temperature = Enum.min(temperatures)
    high_temperature = Enum.max(temperatures)

    conditions = Enum.map(snapshots, fn snapshot -> snapshot.weather_title end)

    has_rain = Enum.any?(conditions, fn condition -> condition == "Rain" end)
    has_snow = Enum.any?(conditions, fn condition -> condition == "Snow" end)
    has_clouds = Enum.any?(conditions, fn condition -> condition == "Clouds" end)

    primary_condition = cond do
      has_rain ->
        "Rain"
      has_snow ->
        "Snow"
      has_clouds ->
        "Clouds"
      true ->
        "Clear"
    end

    weather_icon = cond do
      has_rain ->
        "10d"
      has_snow ->
        "13d"
      has_clouds ->
        "03d"
      true ->
        "01d"
    end

    %{
      time: day_epoch,
      high_temperature: high_temperature,
      low_temperature: low_temperature,
      primary_condition: primary_condition,
      weather_icon: weather_icon
    }
  end

  defp snapshots_for_day(snapshots, start_of_day, end_of_day) do
    Enum.filter(snapshots, fn snapshot -> snapshot.forecast_time >= start_of_day && snapshot.forecast_time <= end_of_day end)
  end
end
