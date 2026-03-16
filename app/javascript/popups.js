document.addEventListener("turbo:load", () => {

  console.log("rewards.js loaded");

  const cards = document.querySelectorAll(".js-open-reward-popup");
  const popups = document.querySelectorAll(".js-reward-popup");

  cards.forEach(card => {
    card.addEventListener("click", () => {

      const rewardId = card.dataset.rewardId;

      const popup = document.querySelector(
        `.js-reward-popup[data-reward-id="${rewardId}"]`
      );

      if (!popup) {
        console.log("popup not found");
        return;
      }

      popup.classList.remove("hidden");

    });
  });

  popups.forEach(popup => {

    const closeBtn = popup.querySelector(".js-close-modal");
    const overlay = popup.querySelector(".modal-overlay");

    [closeBtn, overlay].forEach(el => {
      el?.addEventListener("click", () => {
        popup.classList.add("hidden");
      });
    });

  });

});