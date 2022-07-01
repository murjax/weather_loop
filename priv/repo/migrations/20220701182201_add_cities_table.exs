defmodule WeatherLoop.Repo.Migrations.AddCitiesTable do
  use Ecto.Migration

  def change do
    create table("cities") do
      add :name, :string
      add :latitude, :string
      add :longitude, :string

      timestamps()
    end
  end
end
