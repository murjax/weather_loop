defmodule WeatherLoop.Cities.City do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cities" do
    field :name, :string
    field :latitude, :string
    field :longitude, :string

    timestamps()
  end

  def changeset(city, params) do
    city
    |> cast(params, [:name, :latitude, :longitude])
    |> validate_required([:name, :latitude, :longitude])
  end
end
