import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  // title: 入力フィールド、site: 公式サイトURL表示用、suggestions: 補完候補リスト
  static targets = ["title", "site", "suggestions"];

  // コントローラーが接続されたときに実行（デバッグ用ログ）
  connect() {
    console.log("AnimeSearchController が接続されました");
  }

  // 入力イベントに応じてAnnict APIに検索リクエストを送る
  autocomplete() {
    let title = this.titleTarget.value.trim(); // 入力値の前後の空白を削除

    // 入力が短すぎる場合は補完候補を消して終了
    if (title.length < 2) {
      this.clearSuggestions();
      return;
    }

    // サーバーに検索クエリを送信
    fetch(`/api/anime_search_suggestions?title=${encodeURIComponent(title)}`)
      .then(response => response.json()) // JSON形式で受け取り
      .then(data => {
        this.showSuggestions(data); // 補完候補の表示
      })
      .catch(error => console.error("Error fetching suggestions:", error)); // エラー処理
  }

  // 補完候補を画面に表示する
  showSuggestions(animes) {
    this.clearSuggestions(); // まず既存の候補をクリア

    // 各候補をリスト項目として追加
    animes.forEach(anime => {
      const li = document.createElement("li");
      li.textContent = anime.title;
      li.classList.add("cursor-pointer", "hover:bg-gray-200", "px-2", "py-1");

      // 候補がクリックされたらフォームに反映＆URLもセット
      li.addEventListener("click", () => {
        this.titleTarget.value = anime.title;
        if (anime.official_site_url) {
          this.siteTarget.value = anime.official_site_url;
        }
        this.clearSuggestions(); // 候補リストを非表示に
      });

      this.suggestionsTarget.appendChild(li); // 候補リストに追加
    });

    // 非表示状態を解除して表示
    this.suggestionsTarget.classList.remove("hidden");
  }

  // 補完候補をすべてクリアし、非表示にする
  clearSuggestions() {
    this.suggestionsTarget.innerHTML = ""; // 内容を空に
    this.suggestionsTarget.classList.add("hidden"); // 非表示に
  }
}
