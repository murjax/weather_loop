let musicStarted = false;
const toggleMusicButton = document.getElementById("toggle-music");

if (toggleMusicButton) {
  toggleMusicButton.addEventListener('click', toggleMusic, false);
}

function toggleMusic() {
  const audio = document.getElementById("weather-audio");

  if (musicStarted) {
    musicStarted = false;
    toggleMusicButton.innerHTML = '<i class="fa-solid fa-play"></i>';
    audio.pause();
  } else {
    musicStarted = true;
    toggleMusicButton.innerHTML = '<i class="fa-solid fa-pause"></i>';
    audio.play();
  }
}

function currentDate() {
  const date = new Date();
  const formattedDate = date.toDateString();
  const dateElement = document.getElementById("date");

  if (dateElement) {
    dateElement.innerText = formattedDate;
    setTimeout(function(){ currentDate() }, 1000);
  }
}
currentDate();

function currentTime() {
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
    setTimeout(function(){ currentTime() }, 1000);
  }
}
currentTime();

const carousel = document.querySelector(".carousel");
if (carousel) {
  const flickity = new Flickity(carousel, {
    wrapAround: true,
    autoPlay: 10000,
    pauseAutoPlayOnHover: false,
    prevNextButtons: false
  });
}
