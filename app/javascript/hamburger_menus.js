document.addEventListener("turbo:load", function() {
  const toggle = document.getElementById("menuToggle");
  const menu = document.getElementById("sideMenu");
  const overlay = document.getElementById("overlay");

  toggle.addEventListener("click", function() {
    menu.classList.toggle("active");
    overlay.classList.toggle("active");
  });

  overlay.addEventListener("click", function() {
    menu.classList.remove("active");
    overlay.classList.remove("active");
  });
});