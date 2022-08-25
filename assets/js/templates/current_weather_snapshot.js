const render = function renderCurrentWeatherSnapshot(snapshot) {
  const element = document.getElementById("current-weather-snapshot");
  const html = `
    <div class="text-xl mb-2">Currently</div>

    <div class="flex">
      <div class="text-5xl">${snapshot.temperature}°</div>
      <img src="${snapshot.icon_url}" />
    </div>
    <p>Feels Like: ${snapshot.feels_like}°</p>
    <p>Conditions: ${snapshot.weather_title}</p>

    <table class="table-auto w-full mt-3">
      <tbody>
        <tr class="border-b">
          <td>Humidity</td>
          <td>${snapshot.humidity}%</td>
        </tr>
        <tr class="border-b">
          <td>Visibility</td>
          <td>
            ${snapshot.visibility} miles
          </td>
        </tr>
        <tr class="border-b">
          <td>Wind</td>
          <td>
            ${snapshot.wind}
          </td>
        </tr>
        <tr class="border-b">
          <td>Sunrise</td>
          <td>
            ${snapshot.sunrise}
          </td>
        </tr>
        <tr class="border-b">
          <td>Sunset</td>
          <td>
            ${snapshot.sunset}
          </td>
        </tr>
      </tbody>
    </table>
  `;

  element.innerHTML = html;
}

export default render;
