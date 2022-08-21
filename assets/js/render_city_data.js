import renderCurrentWeatherSnapshot from "./templates/current_weather_snapshot";
import renderForecastSnapshots from "./templates/forecast_snapshot";
import renderDayForecasts from "./templates/day_forecast";

async function fetchCityData(cityId) {
  const response = await fetch(`http://localhost:4000/api/cities/${cityId}`);
  return response.json();
}

const renderCityData = async function renderCityData(cityId) {
  const data = await fetchCityData(cityId);
  if (!data) { return; }

  const currentWeatherSnapshot = data.snapshots.current_weather_snapshot;
  const forecastSnapshots = data.snapshots.forecast_snapshots;
  const dayForecasts = data.snapshots.day_forecasts;

  renderCurrentWeatherSnapshot(currentWeatherSnapshot);
  renderForecastSnapshots(forecastSnapshots);
  renderDayForecasts(dayForecasts);
}

export default renderCityData;
