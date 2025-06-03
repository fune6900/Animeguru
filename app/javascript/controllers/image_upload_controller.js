import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="image-upload"
export default class extends Controller {
  static targets = ["input", "cacheField"]
  static values = { type: String }

  upload() {
    const file = this.inputTarget.files[0]
    if (!file) return

    const formData = new FormData()
    formData.append("file", file)
    formData.append("type", this.typeValue)

    fetch("/seichi_memos/upload_image", {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: formData
    })
      .then(response => {
        if (!response.ok) throw new Error("Upload failed")
        return response.json()
      })
      .then(data => {
        this.cacheFieldTarget.value = data.cache_name
      })
      .catch(error => {
        console.error("画像アップロードに失敗しました:", error)
      })
  }
}
