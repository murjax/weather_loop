defmodule WeatherLoop.WeatherRefresher do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    :timer.send_interval(600_000, :work)
    {:ok, state}
  end

  def handle_info(:work, state) do
    refresh_weather()
    {:noreply, state}
  end

  defp refresh_weather do
    cities = WeatherLoop.Cities.list_cities()

    Enum.each(cities, fn city -> WeatherLoop.WeatherApi.capture_snapshots(city) end)

    WeatherLoopWeb.Endpoint.broadcast!("city", "weather_updated", %{message: "weather updated"})
  end
end
