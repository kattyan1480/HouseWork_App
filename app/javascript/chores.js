import flatpickr from "flatpickr"
import { Japanese } from "flatpickr/dist/l10n/ja"

document.addEventListener("turbo:load", () => {
  const button = document.getElementById("open-calendar-btn")
  const input  = document.getElementById("execute_dates")

  if (!button || !input) return

  // hidden_field に入っている既存値（編集画面用）
  const dates = input.value
    ? input.value.split(",")
    : []

  const fp = flatpickr(input, {
    mode: "multiple",
    dateFormat: "Y-m-d",
    locale: Japanese,
    defaultDate: dates,
    clickOpens: false,   // ← 超重要
    onChange: function(selectedDates, dateStr) {
      input.value = dateStr
      button.textContent =
        selectedDates.length > 0
          ? `${selectedDates.length}日選択中`
          : "クリックして日付を選択してください"
    }
  })

  // ボタンを押したらカレンダーを開く
  button.addEventListener("click", () => {
    fp.open()
  })
})