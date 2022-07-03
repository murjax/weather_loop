defmodule WeatherLoop.Repo.Migrations.AddRadarUrlToCities do
  use Ecto.Migration

  def change do
    alter table(:cities) do
      add :radar_url, :text
    end
  end
end
