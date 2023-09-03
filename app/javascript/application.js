// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "trix";
import "@rails/actiontext";
import "controllers";

// For smaller screens, set the height of the main element to the height of
// the window so the footer can rest at the bottom of the page, regardless of
// whether the address bar is visible or not. For larger screens, remove the
// height so the content of the page can determine its own height.
const resizeMain = () => {
  const mainElement = document.querySelector("main");

  if (window.innerWidth >= 640) {
    mainElement.style.height = "";
  } else {
    const windowHeight = window.innerHeight;
    mainElement.style.height = `${windowHeight}px`;
  }
};

// Set the height of #scrollable elements to the height of the window so that it
// can scroll its entire height. This is necessary because the bottom of
// scrollable elements gets pushed off the bttom of the screen by the address
// bar on mobile devices, obscuring the bottom content.
const adjustScrollableHeight = () => {
  const scrollable = document.getElementById("scrollable");
  if (!scrollable) return;

  const windowHeight = window.innerHeight;
  scrollable.style.height = windowHeight + "px";
};

document.addEventListener("turbo:load", () => {
  resizeMain();
  adjustScrollableHeight();

  window.addEventListener("resize", () => {
    resizeMain();
    adjustScrollableHeight();
  });
});
