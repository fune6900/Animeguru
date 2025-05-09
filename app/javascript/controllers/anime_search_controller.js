import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["title", "site"];

  // コントローラーがHTMLに適用されたときに実行される（デバッグ用）
  connect() {
    console.log("AnimeSearchController が接続されました");
  }

  // 作品タイトルの入力時にAnnict APIを検索
  search() {
    // 入力フォームからタイトルを取得し、前後の空白を削除
    let title = this.titleTarget.value.trim();
    // 2文字未満の入力の場合は処理を中断（無駄なAPIリクエストを防ぐ）
    if (title.length < 2) return;

    // Annict APIへ検索リクエストを送信
    fetch(`/api/anime_search?title=${encodeURIComponent(title)}`)
      .then(response => response.json()) // レスポンスをJSONに変換
      .then(data => {
        // 取得した公式サイトURLを入力フォームに反映
        if (data.official_site_url) {
          this.siteTarget.value = data.official_site_url;
        }
      })
      .catch(error => console.error("Error fetching anime data:", error)); // エラーハンドリング
  }
}
