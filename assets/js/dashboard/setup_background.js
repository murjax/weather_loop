const backgrounds = [
  'background-1',
  'background-2',
  'background-3',
  'background-4'
];
let currentBackgroundIndex = 0;

const setupBackground = function setupBackground() {
  setInterval(function() {
    const currentBackground = document.getElementById(backgrounds[currentBackgroundIndex]);
    const nextIndex = (currentBackgroundIndex === backgrounds.length - 1) ? 0 : currentBackgroundIndex + 1;
    const nextBackground = document.getElementById(backgrounds[nextIndex]);

    currentBackground.classList.remove('fadein');
    currentBackground.classList.add('fadeout');

    nextBackground.classList.remove('fadeout');
    nextBackground.classList.add('fadein');

    currentBackgroundIndex = nextIndex;
  }, 600000);
}

export default setupBackground;
