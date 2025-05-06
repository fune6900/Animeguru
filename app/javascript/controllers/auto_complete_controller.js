// app/javascript/controllers/autocomplete_controller.js
import { Controller } from "@hotwired/stimulus"

// Stimulusのオートコンプリートコントローラー
export default class extends Controller {
  // DOMから取得するターゲットを宣言（input欄と検索結果の表示領域）
  static targets = [ "input", "results" ]

  // コントローラーが接続されたときに実行される（初期化処理）
  connect() {
    console.log("Autocomplete controller connected!"); // デバッグ用ログ出力

    // 初期状態では候補リストを非表示にする
    this.resultsTarget.hidden = true

    // 入力時およびフォーカス時に検索を発動
    this.inputTarget.addEventListener("input", this.search.bind(this))
    this.inputTarget.addEventListener("focus", this.search.bind(this))

    // ページ全体でクリックイベントを監視し、入力欄外をクリックしたら候補を隠す
    document.addEventListener("click", this.hideResults.bind(this))
  }

  // 候補リストを非表示にする処理
  hideResults(event) {
    // クリックされた場所がコントローラー外なら非表示にする
    if (!this.element.contains(event.target)) {
      this.resultsTarget.hidden = true
    }
  }

  // 入力内容をもとに検索を行う非同期処理
  async search() {
    console.log("Search triggered with:", this.inputTarget.value); // デバッグ用ログ出力

    // 入力値を取得し、前後の空白を除去
    const query = this.inputTarget.value.trim()

    // 入力が2文字未満なら候補を表示しない
    if (query.length < 2) {
      this.resultsTarget.hidden = true
      return
    }

    try {
      // 指定されたエンドポイントに検索キーワードを送信（オートコンプリートAPI）
      const response = await fetch(`/seichi_memos/autocomplete?term=${encodeURIComponent(query)}`)

      // レスポンスをJSONとして受け取る
      const data = await response.json()

      // 既存の候補をすべてクリア
      this.resultsTarget.innerHTML = ""

      // 候補が存在する場合のみ表示
      if (data.length > 0) {
        this.resultsTarget.hidden = false

        // 各候補データに対してHTML要素を生成し追加
        data.forEach(item => {
          const element = document.createElement("div") // div要素生成
          element.classList.add("p-2", "hover:bg-gray-100", "cursor-pointer") // スタイル付与
          element.textContent = item.value // 表示テキストを設定
          element.dataset.id = item.id // データ属性にIDを保持
          element.addEventListener("click", () => this.selectResult(item)) // クリックで選択処理
          this.resultsTarget.appendChild(element) // 結果エリアに追加
        })
      } else {
        // 候補がなければ非表示
        this.resultsTarget.hidden = true
      }
    } catch (error) {
      // エラーが起きたらログ出力
      console.error("オートコンプリートエラー:", error)
    }
  }

  // 候補をクリックしたときの処理
  selectResult(item) {
    // 選ばれた値を入力欄に設定
    this.inputTarget.value = item.value
    // 候補リストを非表示に
    this.resultsTarget.hidden = true
  }
}
