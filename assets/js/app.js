// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

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

  document.getElementById("clock").innerText = time;
  let t = setTimeout(function(){ currentTime() }, 1000);
}
currentTime();

if (toggleMusicButton) {
  toggleMusicButton.addEventListener('click', toggleMusic, false);
}

const carousel = document.querySelector(".carousel");
if (carousel) {
  const flickity = new Flickity(carousel, {
    wrapAround: true,
    autoPlay: 10000,
    pauseAutoPlayOnHover: false,
    prevNextButtons: false
  });
}
