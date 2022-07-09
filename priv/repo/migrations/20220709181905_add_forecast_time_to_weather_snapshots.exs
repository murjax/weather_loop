defmodule WeatherLoop.Repo.Migrations.AddForecastTimeToWeatherSnapshots do
  use Ecto.Migration

  def change do
    alter table(:weather_snapshots) do
      add :forecast_time, :integer
    end
  end
end
