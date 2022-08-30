# WeatherLoop

A simple weather dashboard built on Phoenix.

### Features:
- Looping weather info in a carousel, including current weather, NWS radar, hourly forecast, daily forecast.
- Rotating background images.
- Optional background audio.

### Requirements:
- Elixir 1.12 (or greater)
- Postgres 11 (or greater)
- OpenWeatherMap API keys

### Local setup:
  1. Clone project: `git clone git@github.com:murjax/weather_loop.git`
  2. Navigate into folder `cd weather_loop`
  3. Add background audio file to `/priv/static/audio/weather_audio.mp3`
  4. Add background images to `/priv/static/images/backgrounds`. Files are named by number (e.g. 1.jpg, 2.jpg, etc).
  5. Add `config/application.yml` with variable `weather_api_key` set to your OpenWeatherMap API key.
  6. Install dependencies: `mix deps.get`
  7. Setup database `mix ecto.setup`
  8. Open IEx to add a city: `iex -S mix`
  9. Create a map with city attributes:
  ```
    attributes = %{
      name: "Jacksonville",
      state: "FL",
      latitude: "30.3193401",
      longitude: "-81.6392728",
      radar_url: "https://radar.weather.gov/"
    }
  ```
  10. Save city with new attributes:
  ```
    WeatherLoop.Cities.create_city(attributes)
  ```
  11. Close the IEx console.
  12. Start the server with `mix phx.server`
  13. Navigate to http://localhost:4000.
  14. Click on your city.
  15. Your dashboard is now running!
