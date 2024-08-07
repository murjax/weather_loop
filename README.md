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
  3. Add `.env` with variable `WEATHER_API_KEY` set to your OpenWeatherMap API key.
  4. Install dependencies: `mix deps.get`
  5. Setup database `mix ecto.setup`
  6. Start the server with `mix phx.server`
  7. Create a folder named `media` in the root directory. This contains file uploads.
  8. Navigate to http://localhost:4000.
  9. Register a new user.
  10. Click "Add a city" to add a new city.
  11. Fill in the city details. Set the radar url to a variant of https://radar.weather.gov. You can zoom in and configure the radar, then copy the link into this field.
  12. Add background image and optional audio file to run on your city page.
  13. Save the city.
  14. Click on your city.
  15. Your dashboard is now running!

### API
Each user account comes with a UUID API token. To view, visit `/users/settings`.

#### Endpoints
- `/api/cities` - Shows list of cities with basic information.
- `/api/cities/:id` - Shows city info, current weather, hourly forecasts, and day forecasts.

# Source
Data is sourced from [OpenWeatherMap](https://openweathermap.org/) and [sunrisesunset.io](https://sunrisesunset.io/).
