let musicStarted = false;
const toggleMusicButton = document.getElementById("toggle-music");

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

const setupAudio = function setupAudio() {
  if (toggleMusicButton) {
    toggleMusicButton.addEventListener('click', toggleMusic, false);
  }
}

export default setupAudio;
