import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["seichi", "address", "postalcode"]

  search(event) {
    event.preventDefault(); // フォームの自動送信を防ぐ

    // ユーザーが入力した聖地名を取得し、APIリクエストを送信
    fetch(`/seichi_search?query=${encodeURIComponent(this.seichiTarget.value)}`)
      .then(response => response.json()) // レスポンスをJSONに変換
      .then(data => {
        // 取得したデータをフォームにセット
        this.addressTarget.value = data.address || ""; // 住所をセット（データがない場合は空）
        this.postalcodeTarget.value = data.postal_code || ""; // 郵便番号をセット（データがない場合は空）
      });
  }
}
