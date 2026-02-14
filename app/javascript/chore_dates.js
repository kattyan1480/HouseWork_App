import flatpickr from "flatpickr"
import { Japanese } from "flatpickr/dist/l10n/ja"

document.addEventListener("turbo:load", () => {
  const modal = document.getElementById("chore-modal")
  if (!modal) return

  const modalContent = modal.querySelector(".modal-content")
  const title = document.getElementById("modal-chore-title")
  const openButtons = document.querySelectorAll(".js-open-modal")
  const overlay = modal.querySelector(".modal-overlay")

  const detailLink = document.getElementById("modal-detail")
  const deleteLink = document.getElementById("modal-delete")
  const completeForm = document.getElementById("complete-form")

  const rescheduleBtn   = document.getElementById("modal-reschedule")
  const rescheduleInput = document.getElementById("reschedule-execute-at")
  const rescheduleId    = document.getElementById("reschedule-id")

  if (!rescheduleBtn || !rescheduleInput) return

  let picker = null

  // ===== モーダルを開く =====
  openButtons.forEach(button => {
    button.addEventListener("click", () => {

      // タイトル設定（7文字＋…）
      const choreTitle = button.dataset.choreTitle || ""
      title.textContent =
        choreTitle.slice(0, 7) + (choreTitle.length > 7 ? "…" : "")

      const choreDateId = button.dataset.choreDateId

      const choreId = button.dataset.choreId

      // 詳細リンク
      detailLink.href = `/chore_dates/${choreDateId}`

      // 削除リンク
      deleteLink.href = `/chore_dates/${choreDateId}`

      // 完了フォーム
      completeForm.action = `/chore_dates/${choreDateId}/complete`

      // リスケIDセット
      rescheduleId.value = choreDateId

      // モーダル表示
      modal.classList.remove("hidden")

      // ===== flatpickr 初期化（1回だけ）=====
      if (!picker) {
        picker = flatpickr(rescheduleInput, {
          mode: "single",          // 単一選択
          dateFormat: "Y-m-d",
          locale: Japanese,
          appendTo: modalContent,  // モーダル内に表示
          positionElement: rescheduleBtn,
          static: true,            // モーダル内で固定
          disableMobile: true,
          clickOpens: false,       // 自動で開かない
          allowInput: true,        // 入力は防ぐ

          onChange: (selectedDates, dateStr) => {
            // 日付選択後にボタンを「変更する」に切り替え
            rescheduleBtn.textContent = "変更する"
            rescheduleBtn.type = "submit"
          }
        })
      }
    })
  })

  // ===== リスケボタン =====
  rescheduleBtn.addEventListener("click", () => {
    if (rescheduleBtn.type === "button" && picker) {
      picker.open()
    }
  })

  // ===== モーダル閉じる =====
  if (overlay) {
    overlay.addEventListener("click", () => {
      modal.classList.add("hidden")

      if (picker) picker.clear()

      rescheduleBtn.textContent = "リスケ"
      rescheduleBtn.type = "button"
      rescheduleInput.value = ""
      rescheduleId.value = ""
    })
  }
})
