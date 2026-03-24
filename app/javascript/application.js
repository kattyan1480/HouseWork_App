import "@hotwired/turbo-rails"
import "controllers"
import "users"
import "rewards"
import "chores"
import "chore_dates"
import "popups"
import "flash_messages"
import "hamburger_menus"
import "categories"

if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/service-worker.js');
}