import flatpickr from "flatpickr"
import { Japanese } from "flatpickr/dist/l10n/ja"

document.addEventListener("turbo:load", () => {
  const el = document.getElementById("execute_dates")
  if (!el) return

  flatpickr(el, {
    mode: "multiple",
    dateFormat: "Y-m-d",
    locale: Japanese
  })
})