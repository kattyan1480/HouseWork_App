document.addEventListener("turbo:load", () => {
  const input = document.getElementById("stamp_input");
  const button = document.getElementById("stamp_button");
  const filename = document.getElementById("stamp_filename");
  const preview = document.getElementById("stamp_preview");

  if (!input) return;

  button.addEventListener("click", () => input.click());

  input.addEventListener("change", () => {
    const file = input.files[0];
    if (!file) return;

    filename.textContent = file.name;

    const reader = new FileReader();
    reader.onload = e => {
      preview.src = e.target.result;
      preview.style.display = "block";
    };
    reader.readAsDataURL(file);
  });
});