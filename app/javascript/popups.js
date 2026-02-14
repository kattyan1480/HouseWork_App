document.addEventListener("turbo:load", () => {
  const wrapper = document.querySelector(".member-select");
  if (!wrapper) return;

  const toggle = wrapper.querySelector(".js-toggle-member");
  const dropdown = wrapper.querySelector(".member-select-dropdown");

  if (!toggle || !dropdown) return;

  toggle.onclick = (e) => {
    e.stopPropagation();
    dropdown.style.display =
      dropdown.style.display === "block" ? "none" : "block";
  };

  document.onclick = (e) => {
    if (!e.target.closest(".member-select")) {
      dropdown.style.display = "none";
    }
  };
});
