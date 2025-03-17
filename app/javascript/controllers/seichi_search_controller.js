import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["seichi", "address", "postalcode"]

  search(event) {
    event.preventDefault(); // フォームの自動送信を防ぐ

    // ユーザーが入力した聖地名を取得し、APIリクエストを送信
    fetch(`/api/seichi_search?query=${encodeURIComponent(this.seichiTarget.value)}`)
      .then(response => response.json()) // レスポンスをJSONに変換
      .then(data => {
        if (data.address) {
          let formattedAddress = data.address
            .replace(/^日本、/, '')  // 「日本、」を削除
            .replace(/〒\d{3}-\d{4}/, '') // 郵便番号を削除
            .trim(); // 余分なスペースを削除

          this.addressTarget.value = formattedAddress; // 修正後の住所をセット
        } else {
          this.addressTarget.value = ""; // 住所をセット（データがない場合は空）
        }

        this.postalcodeTarget.value = data.postal_code || ""; // 郵便番号をセット（データがない場合は空）
      })
      .catch(error => console.error("エラー:", error));
  }
}
