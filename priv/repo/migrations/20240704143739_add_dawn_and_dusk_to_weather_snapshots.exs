defmodule WeatherLoop.Repo.Migrations.AddDawnAndDuskToWeatherSnapshots do
  use Ecto.Migration

  def change do
    alter table(:weather_snapshots) do
      add :dawn, :integer
      add :dusk, :integer
    end
  end
end
