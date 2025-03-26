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
        this.currentStep++ // 保存成功時に次のステップへ進む
        this.showStep() // ステップを更新して表示
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
}
