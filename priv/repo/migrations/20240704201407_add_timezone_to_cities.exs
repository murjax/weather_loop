defmodule WeatherLoop.Repo.Migrations.AddTimezoneToCities do
  use Ecto.Migration

  def change do
    alter table(:weather_snapshots) do
      remove :time_zone
    end

    alter table(:cities) do
      add :time_zone, :string
    end
  end
end
