// app/javascript/flash.js

document.addEventListener("turbo:load", handleFlash)
document.addEventListener("DOMContentLoaded", handleFlash)

function handleFlash() {
  // 全ての flash 要素を取得
  const flashes = document.querySelectorAll(".js-flash")

  flashes.forEach(flash => {
    // 表示アニメーション
    setTimeout(() => {
      flash.classList.add("flash-show")
    }, 100)

    // 3秒後に消す
    setTimeout(() => {
      flash.classList.remove("flash-show")
    }, 3000)
  })
}