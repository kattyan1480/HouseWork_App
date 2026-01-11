import flatpickr from "flatpickr"
import { Japanese } from "flatpickr/dist/l10n/ja"

document.addEventListener("turbo:load", () => {
  const el = document.getElementById("execute_dates")
  if (!el) return

  // inputに既に入っている値を取得
  const dates = el.value
    ? el.value.split(",")
    : []

  flatpickr(el, {
    mode: "multiple",
    dateFormat: "Y-m-d",
    locale: Japanese,
    defaultDate: dates
  })
})