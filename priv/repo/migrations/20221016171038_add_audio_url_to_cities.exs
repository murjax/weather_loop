defmodule WeatherLoop.Repo.Migrations.AddAudioUrlToCities do
  use Ecto.Migration

  def change do
    alter table(:cities) do
      add :audio_url, :string
    end
  end
end
