import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="genre-modal"
export default class extends Controller {
  static targets = ["checkbox", "display"]

  connect() {
    this.updateDisplay()
  }

  update() {
    this.updateDisplay()
  }

  updateDisplay() {
    // 表示エリアを空にする
    this.displayTarget.innerHTML = ""

    // チェックされたタグを収集
    this.checkboxTargets.filter(cb => cb.checked).forEach(cb => {
      const name = cb.dataset.tagName
      const badge = document.createElement("span")
      badge.className = "bg-primary text-white px-3 py-1 rounded-full text-sm mr-1 mb-1 inline-block"
      badge.textContent = name
      this.displayTarget.appendChild(badge)
    })
  }
}
