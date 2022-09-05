defmodule WeatherLoopWeb.CityLive do
  use WeatherLoopWeb, :live_view

  alias WeatherLoop.WeatherSnapshots
  alias WeatherLoop.Cities

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    city = Cities.get_city!(id)
    collection = WeatherSnapshots.get_decorated_snapshot_collection_for_city_id(id)

    if connected?(socket) do
      WeatherLoopWeb.Endpoint.subscribe("city")
    end

    socket = assign(socket,
      city: city,
      current_weather_snapshot: collection[:current_weather_snapshot],
      forecast_snapshots: collection[:forecast_snapshots],
      day_forecasts: collection[:day_forecasts]
    )

    {:ok, socket}
  end

  @impl true
  def handle_info(%{event: "weather_updated", payload: _message}, socket) do
    id = socket.assigns.city.id
    collection = WeatherSnapshots.get_decorated_snapshot_collection_for_city_id(id)

    socket = assign(socket,
      current_weather_snapshot: collection[:current_weather_snapshot],
      forecast_snapshots: collection[:forecast_snapshots],
      day_forecasts: collection[:day_forecasts]
    )

    {:noreply, socket}
  end
end
