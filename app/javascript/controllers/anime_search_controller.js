import { Controller } from "@hotwired/stimulus";

// Stimulusのコントローラーを作成
export default class extends Controller {
  // Stimulusのターゲット要素（HTMLの特定の要素を操作するために指定）
  static targets = ["title", "site", "image"];

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
        // 取得した作品画像のURLを入力フォームに反映
        if (data.image_url) {
          this.imageTarget.value = data.image_url;
        }
      })
      .catch(error => console.error("Error fetching anime data:", error)); // エラーハンドリング
  }
}
