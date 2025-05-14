import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  // 🔹 ステップ要素とフォーム要素をターゲットとして指定
  static targets = ["step", "form"]

  // 🔹 コントローラーが接続されたときに実行される
  connect() {
    this.currentStep = 0 // 初期ステップを 0（最初のステップ）に設定
    this.showStep() // 初回のステップを表示
  }

  // 🔹 「次へ」ボタンが押されたときに実行
  next(event) {
    event.preventDefault() // フォームのデフォルト送信を防ぐ
    this.saveData() // 現在のステップのデータをセッションに保存
  }

  // 🔹 「戻る」ボタンが押されたときに実行
  prev(event) {
    event.preventDefault() // フォームのデフォルト送信を防ぐ
    if (this.currentStep > 0) {
      this.currentStep-- // 1つ前のステップへ戻る
      this.showStep() // ステップを更新して表示
      this.clearErrors() // エラーメッセージを消す
    }
  }

  // 🔹 現在のステップのデータをセッションに保存
  saveData() {
    const formData = new FormData(this.formTarget) // フォームのデータを取得

    fetch(`/seichi_memos/update_session?step=${this.currentStepName()}`, {
      method: "POST", // データを送信
      body: formData, // フォームのデータを送る
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content // CSRFトークンを追加
      }
    }).then(response => {
      if (response.ok) {
        if (this.currentStepName() === "confirm") {
          window.location.href = "/seichi_memos/confirm"
          return
        }

        this.currentStep++
        this.showStep()
        this.clearErrors()

        // 成功時はエラーメッセージを非表示にして空にする
        const errorContainer = document.getElementById("form-errors")
        errorContainer.classList.add("hidden")
        errorContainer.innerHTML = ""
      } else {
        return response.json().then(data => {
          const errorContainer = document.getElementById("form-errors")
          errorContainer.classList.remove("hidden")
          errorContainer.innerHTML = `
            <div class="bg-red-100 border-l-4 border-red-500 text-red-800 p-4 rounded-md shadow-sm space-y-2 mb-6">
              <div class="flex items-center mb-2">
                <svg class="w-5 h-5 mr-2 text-red-500" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4m0 4h.01M12 2a10 10 0 100 20 10 10 0 000-20z"/>
                </svg>
                <span class="font-semibold">入力内容に問題があります：</span>
              </div>
              <div class="list-disc list-inside pl-4 text-sm text-red-700 space-y-1">
                ${data.errors.map(error => `<li>${error}</li>`).join("")}
              </div>
            </div>
          `
        })
      }
    })
  }

  // 🔹 現在のステップのみ表示し、他のステップを非表示にする
  showStep() {
    this.stepTargets.forEach((step, index) => {
      step.style.display = index === this.currentStep ? "block" : "none" // 現在のステップのみ表示
    })
  }

  currentStepName() {
    switch (this.currentStep) {
      case 0: return "memo"
      case 1: return "place"
      case 2: return "anime"
      case 3: return "confirm"
      default: return "memo"
    }
  }

  showErrors(errors) {
    const errorContainer = document.querySelector("#form-errors");
    if (!errorContainer) return;
    errorContainer.innerHTML = `
      <div class="text-red-500 space-y-1">
        ${errors.map(error => `<p>${error}</p>`).join("")}
      </div>
    `;
    errorContainer.classList.remove("hidden");
  }

  clearErrors() {
    const errorContainer = document.querySelector("#form-errors")
    if (errorContainer) {
      errorContainer.innerHTML = ""
      errorContainer.classList.add("hidden")
    }
  }
}
