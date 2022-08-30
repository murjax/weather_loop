import "./city_socket.js"
import setupAudio from "./setup_audio";
import setupClock from "./setup_clock";
import setupCarousel from "./setup_carousel";
import setupBackground from "./setup_background";
import renderCityData from "./render_city_data";

const headerElement = document.getElementById("dashboard-header");

if (headerElement) {
  const cityId = headerElement.getAttribute("data-city-id");
  document.body.style.overflow = "hidden";

  setupAudio();
  setupClock();
  setupCarousel();
  setupBackground();
  renderCityData(cityId);
}
