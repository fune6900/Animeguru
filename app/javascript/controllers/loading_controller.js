import { Controller } from "@hotwired/stimulus"

// Controller for showing loading spinner during form submission
export default class extends Controller {
  static targets = ["spinner"]

  connect() {
    this.hide()
  }

  show() {
    this.spinnerTarget.classList.remove("hidden")
  }

  hide() {
    this.spinnerTarget.classList.add("hidden")
  }
}
