defmodule WeatherLoop.Cities.City do
  use Ecto.Schema
  import Ecto.Changeset

  @encode_fields [
    :name,
    :state,
    :latitude,
    :longitude,
    :radar_url,
    :background_image_url,
    :user_id
  ]
  @derive {Jason.Encoder, only: @encode_fields}

  schema "cities" do
    field :name, :string
    field :state, :string
    field :latitude, :string
    field :longitude, :string
    field :radar_url, :string
    field :background_image_url, :string
    belongs_to :user, WeatherLoop.Accounts.User

    timestamps()
  end

  def changeset(city, params \\ %{}) do
    city
    |> cast(params, [:name, :state, :latitude, :longitude, :radar_url, :background_image_url, :user_id])
    |> validate_required([:name, :state, :latitude, :longitude])
  end
end
