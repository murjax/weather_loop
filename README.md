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
  8. Start the server with `mix phx.server`
  9. Navigate to http://localhost:4000.
  10. Register a new user.
  11. Click "Add a city" to add a new city.
  12. Fill in the city details. Set the radar url to a variant of https://radar.weather.gov. You can zoom in and configure the radar, then copy the link into this field.
  13. Save the city.
  14. Click on your city.
  15. Your dashboard is now running!
