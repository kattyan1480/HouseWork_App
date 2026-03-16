document.addEventListener("turbo:load", () => {

  const cards = document.querySelectorAll(".js-open-reward-popup");

  cards.forEach(card => {

    card.addEventListener("click", () => {

      const rewardId = card.dataset.rewardId;

      const popup = document.querySelector(
        `.js-reward-popup[data-reward-id="${rewardId}"]`
      );

      if (!popup) return;

      popup.classList.remove("hidden");

      const closeBtn = popup.querySelector(".js-close-modal");
      const overlay = popup.querySelector(".modal-overlay");

      [closeBtn, overlay].forEach(el => {
        el?.addEventListener("click", () => {
          popup.classList.add("hidden");
        });
      });

    });

  });

});