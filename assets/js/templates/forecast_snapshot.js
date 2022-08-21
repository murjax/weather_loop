const render = function renderForecastSnapshots(snapshots) {
  const element = document.getElementById("forecast-snapshots");
  let html = '';

  snapshots.forEach((snapshot) => {
    html += `
      <div class="py-4 mx-2 px-2 bg-white rounded-md w-3/12">
        <div class="text-xl mb-2">
          ${snapshot.forecast_time}
        </div>

        <div class="flex">
          <div class="text-5xl">${snapshot.temperature}°</div>
          <img src="${snapshot.icon_url}" />
        </div>
        <p>Feels Like: ${snapshot.feels_like}
        <p>Conditions: ${snapshot.weather_title}
      </div>
    `;
  });

  element.innerHTML = html;
}

export default render;
