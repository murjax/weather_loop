const setupCarousel = function setupCarousel() {
  const carousel = document.querySelector(".carousel");
  if (carousel) {
    const flickity = new Flickity(carousel, {
      wrapAround: true,
      autoPlay: 20000,
      pauseAutoPlayOnHover: false,
      prevNextButtons: false
    });
  }
}

export default setupCarousel;
