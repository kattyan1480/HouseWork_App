import "@hotwired/turbo-rails"
import "controllers"
import "./chores"

document.addEventListener("turbo:load", () => {
  flatpickr(".js-multi-date", {
    mode: "multiple",
    dateFormat: "Y-m-d"
  })
})

