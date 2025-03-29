import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  // 🔹 ステップ要素とフォーム要素をターゲットとして指定
  static targets = ["step", "form"]

  // 🔹 コントローラーが接続されたときに実行される
  connect() {
    console.log("🧙‍♀️ step_form コントローラーが接続されました！");
    console.log("formTarget:", this.formTarget);
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
          // 🔥 assign_cache を動かしてUploaderを復元！
          fetch(`/seichi_memos/prepare_confirm`, {
            method: "GET",
            headers: {
              "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
            }
          }).then(() => {
            this.currentStep++
            this.showStep()
            this.clearErrors()
          })
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
            <div class="space-y-1 text-red-500">
              ${data.errors.map(error => `<p class="pl-2"> ${error}</p>`).join("")}
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
