defmodule WeatherLoop.WeatherSnapshots.WeatherSnapshot do
  use Ecto.Schema
  import Ecto.Changeset

  @changeset_fields [
    :temperature,
    :feels_like,
    :humidity,
    :visibility,
    :wind_speed,
    :wind_direction,
    :weather_title,
    :weather_description,
    :weather_icon,
    :sunrise,
    :sunset,
    :forecast_time,
    :forecast,
    :city_id
  ]

  @required_fields [
    :temperature,
    :feels_like,
    :humidity,
    :weather_title,
    :weather_description,
    :weather_icon,
    :city_id
  ]

  schema "weather_snapshots" do
    field :temperature, :float
    field :feels_like, :float
    field :humidity, :integer
    field :visibility, :integer
    field :wind_speed, :float
    field :wind_direction, :integer
    field :weather_title, :string
    field :weather_description, :string
    field :weather_icon, :string
    field :sunrise, :integer
    field :sunset, :integer
    field :forecast_time, :integer
    field :forecast, :boolean
    belongs_to :city, WeatherLoop.Cities.City

    timestamps()
  end

  def changeset(weather_snapshot, params) do
    weather_snapshot
    |> cast(params, @changeset_fields)
    |> validate_required(@required_fields)
  end
end
