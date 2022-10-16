defmodule WeatherLoop.Repo.Migrations.AddBackgroundImageUrlToCities do
  use Ecto.Migration

  def change do
    alter table(:cities) do
      add :background_image_url, :string
    end
  end
end
