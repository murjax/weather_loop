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

  def get_day_forecasts(snapshots) do
    {:ok, current_time} = Calendar.DateTime.now("America/New_York")

    {:ok, day_one_time} = Calendar.DateTime.add(current_time, 86400)
    day_one_date = Calendar.DateTime.to_date(day_one_time)
    {:ok, day_two_time} = Calendar.DateTime.add(current_time, 172800)
    day_two_date = Calendar.DateTime.to_date(day_two_time)
    {:ok, day_three_time} = Calendar.DateTime.add(current_time, 259200)
    day_three_date = Calendar.DateTime.to_date(day_three_time)

    {:ok, day_one_beginning} = DateTime.new(day_one_date, ~T[00:00:00.000], "America/New_York")
    {:ok, day_one_end} = DateTime.new(day_one_date, ~T[23:59:59.999], "America/New_York")
    day_one_beginning_epoch = DateTime.to_unix(day_one_beginning)
    day_one_end_epoch = DateTime.to_unix(day_one_end)

    {:ok, day_two_beginning} = DateTime.new(day_two_date, ~T[00:00:00.000], "America/New_York")
    {:ok, day_two_end} = DateTime.new(day_two_date, ~T[23:59:59.999], "America/New_York")
    day_two_beginning_epoch = DateTime.to_unix(day_two_beginning)
    day_two_end_epoch = DateTime.to_unix(day_two_end)

    {:ok, day_three_beginning} = DateTime.new(day_three_date, ~T[00:00:00.000], "America/New_York")
    {:ok, day_three_end} = DateTime.new(day_three_date, ~T[23:59:59.999], "America/New_York")
    day_three_beginning_epoch = DateTime.to_unix(day_three_beginning)
    day_three_end_epoch = DateTime.to_unix(day_three_end)

    day_one_snapshots = Enum.filter(snapshots, fn snapshot -> snapshot.forecast_time >= day_one_beginning_epoch && snapshot.forecast_time <= day_one_end_epoch end)
    day_two_snapshots = Enum.filter(snapshots, fn snapshot -> snapshot.forecast_time >= day_two_beginning_epoch && snapshot.forecast_time <= day_two_end_epoch end)
    day_three_snapshots = Enum.filter(snapshots, fn snapshot -> snapshot.forecast_time >= day_three_beginning_epoch && snapshot.forecast_time <= day_three_end_epoch end)

    day_one_forecast = get_day_forecast(day_one_snapshots, day_one_beginning_epoch)
    day_two_forecast = get_day_forecast(day_two_snapshots, day_two_beginning_epoch)
    day_three_forecast = get_day_forecast(day_three_snapshots, day_three_beginning_epoch)

    [day_one_forecast, day_two_forecast, day_three_forecast]
  end

  def get_day_forecast(snapshots, day_epoch) do
    temperatures = Enum.map(snapshots, fn snapshot -> snapshot.temperature end)
    low_temperature = Enum.min(temperatures)
    high_temperature = Enum.max(temperatures)

    conditions = Enum.map(snapshots, fn snapshot -> snapshot.weather_title end)

    has_rain = Enum.any?(conditions, fn condition -> condition == "Rain" end)
    has_clouds = Enum.any?(conditions, fn condition -> condition == "Clouds" end)

    primary_condition = cond do
      has_rain ->
        "Rain"
      has_clouds ->
        "Clouds"
      true ->
        "Clear"
    end

    weather_icon = cond do
      has_rain ->
        "10d"
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

  def delete_snapshots_for_city_id(city_id) do
    from(snapshot in WeatherSnapshot, where: [city_id: ^city_id])
    |> Repo.delete_all
  end
end
