defmodule WeatherLoop.Repo.Migrations.AddForecastBooleanToWeatherSnapshots do
  use Ecto.Migration

  def change do
    alter table(:weather_snapshots) do
      add :forecast, :boolean, default: false
    end
  end
end
