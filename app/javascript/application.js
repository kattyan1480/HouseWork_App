import "@hotwired/turbo-rails"
import "controllers"
import "./chores"
import "./chore_dates"
import "./rewards"
import "./popups"

document.addEventListener("turbo:load", () => {
  // flatpickr の初期化
  flatpickr(".js-multi-date", {
    mode: "multiple",
    dateFormat: "Y-m-d"
  })

  const input = document.getElementById('avatar_input');
  const button = document.getElementById('avatar_button');
  const filename = document.getElementById('avatar_filename');
  const preview = document.getElementById('avatar_preview');

  if (button && input && filename) {
    button.addEventListener('click', () => input.click());

    input.addEventListener('change', function () {
      if (this.files && this.files[0]) {
        const file = this.files[0];

        // ファイル名表示
        filename.textContent = file.name;

        // 🔽 プレビュー表示
        const reader = new FileReader();
        reader.onload = function (e) {
          preview.src = e.target.result;
          preview.style.display = "block";
        };
        reader.readAsDataURL(file);
      } else {
        filename.textContent = '選択されていません';
        preview.style.display = "none";
      }
    });
  }
});
