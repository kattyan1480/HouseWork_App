import flatpickr from "flatpickr"
import { Japanese } from "flatpickr/dist/l10n/ja"

function initCalendar() {
  const button = document.getElementById("open-calendar-btn")
  const input  = document.getElementById("execute_dates")

  if (!button || !input) return

  // 既に初期化済みなら何もしない（重要）
  if (input._flatpickr) return

  const dates = input.value ? input.value.split(",") : []

  const fp = flatpickr(input, {
    mode: "multiple",
    dateFormat: "Y-m-d",
    locale: Japanese,
    defaultDate: dates,
    clickOpens: false, // ←ここ変更
    onChange: (selectedDates, dateStr) => {
      input.value = dateStr
      button.textContent =
        selectedDates.length > 0
          ? `${selectedDates.length}日選択中`
          : "クリックして日付を選択してください"
    }
  })

  button.addEventListener("click", () => {
    fp.open()
  })
}

document.addEventListener("turbo:load", initCalendar)
document.addEventListener("turbo:render", initCalendar)