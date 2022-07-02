defmodule WeatherLoop.Repo.Migrations.AddStateToCities do
  use Ecto.Migration

  def change do
    alter table(:cities) do
      add :state, :string
    end
  end
end
