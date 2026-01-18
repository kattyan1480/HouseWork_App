// ポップアップ用
document.addEventListener("turbo:load", () => {
  const modal = document.getElementById("chore-modal")
  const title = document.getElementById("modal-chore-title")
  const detail = document.getElementById("modal-chore-detail")
  const openButtons = document.querySelectorAll(".js-open-modal")
  const overlay = document.querySelector(".modal-overlay")
  const deleteLink = document.getElementById("modal-delete")

  if (!modal) return

  // モーダルを開く
  openButtons.forEach(button => {
    button.addEventListener("click", () => {

      // ① タイトル・詳細をセット
      title.textContent  = button.dataset.choreTitle
      detail.textContent = button.dataset.choreDetail

      // ② chore_date_id を取得
      const choreDateId = button.dataset.choreDateId

      // ③ 削除リンクのURLをセット
      deleteLink.href = `/chore_dates/${choreDateId}`

      // ④ 表示
      modal.classList.remove("hidden")
    })
  })

  // 閉じる（背景クリック）
  overlay.addEventListener("click", () => {
    modal.classList.add("hidden")
  })

})