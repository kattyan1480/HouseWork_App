import "@hotwired/turbo-rails"
import "controllers"
import flatpickr from "flatpickr"
import "./chores"

document.addEventListener("turbo:load", () => {
  flatpickr(".js-multi-date", {
    mode: "multiple",
    dateFormat: "Y-m-d"
  })
})

