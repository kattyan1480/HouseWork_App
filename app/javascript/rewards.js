document.addEventListener("turbo:load", () => {
  const openBtn = document.querySelector(".js-open-reward-popup");
  if (!openBtn) return;

  const container = openBtn.closest(".reward-container");
  const popup = container?.querySelector(".js-reward-popup");
  const closeBtn = popup?.querySelector(".js-close-reward-popup");
  const overlay = popup?.querySelector(".modal-overlay");

  if (!popup) return;

  openBtn.addEventListener("click", () => {
    popup.classList.remove("hidden");
  });

  [closeBtn, overlay].forEach(el => {
    el?.addEventListener("click", () => {
      popup.classList.add("hidden");
    });
  });
});