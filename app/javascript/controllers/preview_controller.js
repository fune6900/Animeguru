import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "image"]

  show() {
    const file = this.inputTarget.files[0]
    if (file && file.type.match(/^image\//)) {
      const reader = new FileReader()
      reader.onload = (e) => {
        this.imageTarget.src = e.target.result
      }
      reader.readAsDataURL(file)
    }
  }
}
