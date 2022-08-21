const render = function renderDayForecasts(snapshots) {
  const element = document.getElementById("day-forecasts");
  let html = '';

  snapshots.forEach((snapshot) => {
    html += `
      <div class="py-4 mx-2 px-2 bg-white rounded-md w-3/12">
        <div class="text-xl mb-2">
          ${snapshot.time}
        </div>

        <div class="flex">
          <div class="text-5xl">${snapshot.high_temperature}°</div>
          <div class="text-2xl text-slate-400">/${snapshot.low_temperature}°</div>
          <img src="${snapshot.icon_url}" />
        </div>
        <p>Conditions: ${snapshot.primary_condition}
      </div>
    `;
  });

  element.innerHTML = html;
}

export default render;
