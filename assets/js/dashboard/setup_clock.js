function renderCurrentDate() {
  const date = new Date();
  const formattedDate = date.toDateString();
  const dateElement = document.getElementById("date");

  if (dateElement) {
    dateElement.innerText = formattedDate;
    setTimeout(function(){ renderCurrentDate() }, 1000);
  }
}

function renderCurrentTime() {
  let date = new Date();
  let hh = date.getHours();
  let mm = date.getMinutes();
  let ss = date.getSeconds();
  let session = "am";

  if(hh == 0){
    hh = 12;
  }

  if(hh > 12){
    hh = hh - 12;
  }

  if(hh => 12){
    session = "pm";
  }

  hh = (hh < 10) ? "0" + hh : hh;
  mm = (mm < 10) ? "0" + mm : mm;
  ss = (ss < 10) ? "0" + ss : ss;

  let time = hh + ":" + mm + ":" + ss + session;

  const timeElement = document.getElementById("clock");
  if (timeElement) {
    timeElement.innerText = time;
    setTimeout(function(){ renderCurrentTime() }, 1000);
  }
}

const setupClock = function setupClock() {
  renderCurrentDate();
  renderCurrentTime();
}

export default setupClock;
