import flatpickr from "flatpickr"
import { Japanese } from "flatpickr/dist/l10n/ja"

document.addEventListener("turbo:load", () => {
  const modal = document.getElementById("chore-modal")
  if (!modal) return

  const title = document.getElementById("modal-chore-title")
  const openButtons = document.querySelectorAll(".js-open-modal")
  const overlay = modal.querySelector(".modal-overlay")

  const detailLink = document.getElementById("modal-detail")
  const deleteLink = document.getElementById("modal-delete")
  const completeForm = document.getElementById("complete-form")

  const rescheduleBtn    = document.getElementById("modal-reschedule")
  const rescheduleSubmit = document.getElementById("modal-reschedule-submit")
  const rescheduleInput  = document.getElementById("reschedule-execute-at")
  const rescheduleId     = document.getElementById("reschedule-id")

  if (!rescheduleBtn || !rescheduleInput) return

  let picker = null

  // ===== モーダルを開く =====
  openButtons.forEach(button => {
    button.addEventListener("click", () => {
      const choreTitle = button.dataset.choreTitle || ""
      title.textContent = choreTitle.slice(0, 7) + (choreTitle.length > 7 ? "…" : "")

      const choreDateId = button.dataset.choreDateId

      detailLink.href = `/chore_dates/${choreDateId}`
      deleteLink.href = `/chore_dates/${choreDateId}`
      completeForm.action = `/chore_dates/${choreDateId}/complete`
      rescheduleId.value = choreDateId

      modal.classList.remove("hidden")

      if (!picker) {
        picker = flatpickr(rescheduleInput, {
          mode: "single",
          dateFormat: "Y-m-d",
          locale: Japanese,

          // 位置ズレ対策
          appendTo: document.body,
          positionElement: rescheduleBtn,
          position: "auto left",

          static: false,
          disableMobile: true,

          // 入力欄を裏方化
          clickOpens: false,
          allowInput: false,

          onChange: (selectedDates, dateStr) => {
            rescheduleSubmit.disabled = !dateStr
          }
        })

        // ★ズーム防止（最重要）
        rescheduleInput.setAttribute("readonly", true)
      }
    })
  })

  // ===== リスケボタンでカレンダー表示 =====
  rescheduleBtn.addEventListener("click", () => {
    if (picker) {
      picker.open()

      // ★flatpickrの再フォーカスを潰す
      setTimeout(() => {
        rescheduleInput.blur()
      }, 0)
    }
  })

  // ===== モーダル閉じる =====
  if (overlay) {
    overlay.addEventListener("click", () => {
      modal.classList.add("hidden")

      if (picker) picker.clear()

      rescheduleInput.value = ""
      rescheduleId.value = ""
      rescheduleBtn.textContent = "リスケ"
      rescheduleSubmit.disabled = true
    })
  }

  // ===== 完了者選択ドロップダウン =====
  const memberHeaders = document.querySelectorAll(".js-toggle-member")

  memberHeaders.forEach(header => {
    header.addEventListener("click", () => {
      const dropdown = header.nextElementSibling
      if (!dropdown) return

      dropdown.style.display =
        dropdown.style.display === "block" ? "none" : "block"
    })
  })
})