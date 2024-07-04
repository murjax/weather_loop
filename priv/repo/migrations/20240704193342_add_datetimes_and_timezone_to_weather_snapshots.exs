defmodule WeatherLoop.Repo.Migrations.AddDatetimesAndTimezoneToWeatherSnapshots do
  use Ecto.Migration

  def change do
    alter table(:weather_snapshots) do
      remove :dawn
      remove :dusk
      remove :sunrise
      remove :sunset
      remove :forecast_time

      add :dawn, :timestamptz
      add :dusk, :timestamptz
      add :sunrise, :timestamptz
      add :sunset, :timestamptz
      add :forecast_time, :timestamptz
      add :time_zone, :string
    end
  end
end
