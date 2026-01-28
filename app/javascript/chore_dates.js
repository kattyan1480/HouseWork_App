import { Japanese } from "flatpickr/dist/l10n/ja"

document.addEventListener("turbo:load", () => {
  const modal = document.getElementById("chore-modal")
  if (!modal) return

  const title = document.getElementById("modal-chore-title")
  const detail = document.getElementById("modal-chore-detail")
  const openButtons = document.querySelectorAll(".js-open-modal")
  const overlay = document.querySelector(".modal-overlay")

  const deleteLink = document.getElementById("modal-delete")
  const completeForm = document.getElementById("complete-form")

  const rescheduleForm = document.getElementById("reschedule-form")
  const rescheduleBtn  = document.getElementById("modal-reschedule")
  const rescheduleInput = document.getElementById("reschedule-execute-at")

  let picker = null   // ★ flatpickr を保持

  if (!deleteLink || !completeForm || !rescheduleForm) return

  // ===== モーダルを開く =====
  openButtons.forEach(button => {
    button.addEventListener("click", () => {

      // タイトル・詳細
      title.textContent  = button.dataset.choreTitle
      detail.textContent = button.dataset.choreDetail

      const choreDateId = button.dataset.choreDateId

      deleteLink.href = `/chore_dates/${choreDateId}`
      document.getElementById("modal-chore-date-id").value = choreDateId
      completeForm.action = `/chore_dates/${choreDateId}/complete`

      // リスケ用 hidden id
      document.getElementById("reschedule-chore-date-id").value = choreDateId

      // ★ 追加
      rescheduleForm.action =
      `/chore_dates/${choreDateId}/reschedule`

      // 表示
      modal.classList.remove("hidden")

      // ★ flatpickr を「ここで」初期化（1回だけ）
      if (!picker) {
        picker = flatpickr(rescheduleInput, {
          dateFormat: "Y-m-d",
          locale: Japanese,
          onChange: () => {
            rescheduleBtn.textContent = "変更する"
            rescheduleBtn.type = "submit"
          }
        })
      }
    })
  })

  // ===== リスケボタン =====
  rescheduleBtn.addEventListener("click", () => {
    if (rescheduleBtn.type === "button") {
      rescheduleForm.classList.remove("hidden")
      picker.open()
    }
  })

  // ===== 閉じる =====
  overlay.addEventListener("click", () => {
    modal.classList.add("hidden")

    // 状態リセット
    rescheduleBtn.textContent = "リスケ"
    rescheduleBtn.type = "button"
    rescheduleInput.value = ""
  })
})
