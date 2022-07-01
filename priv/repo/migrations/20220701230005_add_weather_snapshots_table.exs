defmodule WeatherLoop.Repo.Migrations.AddWeatherSnapshotsTable do
  use Ecto.Migration

  def change do
    create table("weather_snapshots") do
      add :temperature, :float
      add :feels_like, :float
      add :humidity, :integer
      add :visibility, :integer
      add :wind_speed, :float
      add :wind_direction, :integer
      add :weather_title, :string
      add :weather_description, :string
      add :weather_icon, :string
      add :sunrise, :integer
      add :sunset, :integer
      add :city_id, references(:cities)

      timestamps()
    end
  end
end
