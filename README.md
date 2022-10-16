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
  3. Add `config/application.yml` with variable `weather_api_key` set to your OpenWeatherMap API key.
  4. Install dependencies: `mix deps.get`
  5. Setup database `mix ecto.setup`
  6. Start the server with `mix phx.server`
  7. Navigate to http://localhost:4000.
  8. Register a new user.
  9. Click "Add a city" to add a new city.
  10. Fill in the city details. Set the radar url to a variant of https://radar.weather.gov. You can zoom in and configure the radar, then copy the link into this field.
  11. Add background image and optional audio file to run on your city page.
  12. Save the city.
  13. Click on your city.
  14. Your dashboard is now running!
