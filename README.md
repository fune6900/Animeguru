## 🧳アニめぐる📷
### 🧳サービス概要
---
アニめぐるはアニメファンの聖地巡礼をサポートする聖地情報共有プラットフォームです。
ユーザーは聖地に関する様々な情報を一元管理できる聖地メモを投稿し、ファン同士で聖地メモの共有を行うことで
好きな作品の聖地巡礼に役立てたり、まだ見ぬ作品を知るきっかけを与えてくれます。

### 🧳このサービスへの思い・作りたい理由
---
- 自身が聖地巡礼の計画を立てる際に聖地に関する作品名やシーンごとの情報、
  聖地の地図情報など聖地に関する様々な情報が点在しておりそれらを一元管理できるサービスがなかったこと

- 既存の聖地巡礼に関するサービスでは「作品に登場する特定の風景を訪れるには、どの時間帯やどの天気にその場所を訪れるのにベストなのか」といった
	聖地巡礼のような特定の作品や趣味に特化した情報や機能が提供されていないという課題があった。

これらの課題を解決し、ファンがよりスムーズかつ感動的な聖地巡礼を楽しめるようなサービスを開発することが必要だと感じています。

### 🧳ユーザー層について
---
- アニメファン：作品に深い愛着を持ち、その舞台を訪れたいと考える層。

- 旅行好き：観光や新しい体験を求め、聖地巡礼を興味のある旅行プランに加えたい層。

- コミュニティ好き：他のファンと体験や情報を共有しながら交流したい層。

### 🧳サービスの利用イメージ
---
- 投稿一覧画面
	- 他のユーザーの聖地メモの投稿が一覧表示されます。
	- 行ってみたい聖地に関する聖地メモの投稿があればブックマークして後でアクセスできます。
- 投稿詳細画面
	- 聖地メモの詳細情報が表示されます。
	- 「いいね」「コメント」「シェア」「ブックマーク」などのアクションが可能です。
- 投稿機能
	- 下記の【機能の実装方針予定】にある【登録できる項目】を設定して投稿できます。
- マイページ機能
	- ユーザー情報の詳細表示やメールアドレス、ユーザー名の編集が可能です。
	- 自分が投稿した聖地メモやブックマークした聖地メモが一覧表示されます。
- 検索画面
	- 聖地メモタイトル、作品名、聖地でのキーワード検索（フリーワード検索）ができます
	- 作品ジャンル別での検索ができます。
	- 地図からの検索ができます。

- 聖地巡礼の際のマナーや注意事項をまとめたページ(コラム)
	- 聖地巡礼を行う際は、作品のファンとしてだけでなく、地元住民や観光地との良好な関係を保つためにマナーや注意点を守ることが大事！！
	- 撮影禁止エリアの確認や地元住民や観光客への配慮など聖地巡礼をする際のマナーや注意点をまとめておくことでマナーやルールを守り、作品と現地にリスペクトを持って行動することを意識させます。

### 🧳ユーザーの獲得について
---
- Xによる宣伝
- ソーシャルポートフォリオへの掲載
- RUNTEQコミュニティのtimesなどに掲載

### 🧳サービスの差別化ポイント・推しポイント
---
【差別化ポイント】 
- ファン同士の交流の場としても：
  - コメント機能やいいね機能を通して同じ作品が好きなファン同士での交流を広げるきっかけにもなります

- 作品の世界観と現実が交わる体験をより深いものに:
	- ベストな訪問時間（季節と時間帯、天候）の情報、聖地の写真と
	聖地が作中に出てくるシーンの画像を比較できる設計でより作品の世界観を体験できる要素を増やします。

- 作品と聖地にリスペクトを： 
	- 聖地巡礼の際のマナーや注意事項をまとめておくことで聖地になっている地域に迷惑をかけることなく、
ユーザーが楽しんで聖地巡礼できる思い出づくりをサポートします。

- ブックマーク機能で気になる聖地の情報管理を簡単に
	- ユーザーが気になる聖地情報を旅先でもすぐにアクセスできます。

### 🧳MVPリリース
---
【認証】
- ユーザー登録機能
- ログイン機能（Device）
- ログアウト機能
- プロフィール機能
	- ユーザー情報の詳細機能
	- メールアドレス、ユーザー名の編集機能
	- 投稿した聖地メモの一覧表示

【検索】
- キーワード検索

【メイン】
- 聖地メモ作成機能
	- 聖地メモの作成と投稿
	- 聖地メモ編集
	- 聖地メモ削除
	- 聖地メモ一覧表示
	- 聖地メモ詳細
- コメント機能
- いいね機能


### 🧳本リリース
---
【認証】
- ログイン機能（Google認証）
- パスワードリセット機能

【メイン】
- ブックマーク機能
- ブックマークした聖地メモの一覧表示
- 聖地巡礼の際のマナーや注意事項をまとめたページ(コラム)

【検索】
- 地図からの検索
- 作品ジャンル検索

【その他】
- Xシェア機能
- お問い合わせフォーム
- 利用規約
- プライバシーポリシー

### 🧳機能の実装方針予定
---
【ログイン機能】
- Deviseとgoogle認証によるログイン方法を実装予定

【聖地メモ作成機能】

- 登録できる項目
  - タイトル
  - 作品ジャンル
  - 作品情報（作品名、作品イメージ、公式サイトURL）
  - 聖地の基本情報（聖地名、郵便番号、住所）
  - 聖地の写真
  - 聖地が登場したシーンなどのスクリーンショットや画像
  - メモ
  - ベストな訪問時間（季節と時間帯、天候）

---

1.タイトル（必須）
- 単一行のテキスト入力フィールド

2.聖地の基本情報（聖地名、郵便番号、住所）（必須）
- Google Maps APIを利用して情報を取得。
- 作成フォームでは地図情報と検索フォームを実装して、ユーザーが「聖地名」を入力し、
「検索」ボタンをクリックすると聖地名や住所、郵便番号を自動的に入力欄に反映します。
 詳細画面で住所、郵便番号、地名、Googleマップの遷移URLを表示します。

3.作品情報作品名、作品イメージ、公式サイトURL（必須）
- Aannict APIを利用して情報を取得。
- 作成フォームで作品名を入力して「概要を取得」ボタンをクリックすると作品の概要を取得。
	概要を自動的に入力欄に反映します。詳細画面で作品名、作品イメージ、公式サイトURLを表示します。

4.聖地の写真（必須）
- 形式: 画像アップロードフィールド
- CarrierWaveを使って画像を保存。

5.聖地が登場したシーンなどのスクリーンショットや画像（必須）
- 形式: 画像アップロードフィールド
- CarrierWaveを使って画像を保存。

6.メモ（任意）
- 形式：テキストエリア
	※聖地のシーンの解説や

7.べストな訪問時間（季節、時間帯、天候）（必須）
- 選択項目：
	- 季節（春, 夏, 秋, 冬）
	- 時間帯（朝、昼、夕方、夜）
	- 天候（晴れ、曇り、雨、雪）
	- 形式：セレクトボックスまたはラジオボタン

8.作品ジャンル
- 形式：トグルリスト
- ジャンルをタグとして登録し、トグルリストから3件まで選択可能

【検索機能】
- キーワード検索 （フリーワード検索）※オートコンプリート機能、マルチ検索を実装予定
	- 作品名、聖地名、タイトルが候補

- 作品ジャンル検索 （トグルリストでの検索）
	- 登録されている作品ジャンルをタグとして登録しておき検索フォームでは
	トグルリストの中からその作品ジャンルのタグを選択して検索できる

- 地図からの検索
	- 登録されている聖地メモがGooglemapの地図上でピンで表示されていて
	そこをクリックするとその聖地メモの詳細画面に遷移する
	※検索結果のページと検索ページは別々のページで実装

### 🧳技術スタック
---

| カテゴリ      | 技術スタック                                                   |
|---------------|----------------------------------------------------------------|
| フロントエンド | Rails (Hotwire/Turbo/Stimulus), JavaScript, Tailwind CSS, daisyUI |
| バックエンド   | Rails(Ruby)                                    |
| データベース   | PosgreSQL                                                        |
| インフラ       | Render.com, Amazon S3                                         |
| 開発環境       | Docker                                                        |
| 認証           | Sorcery, Googleログイン                                        |
| API           | Google Maps API(Google Maps JavaScript API,  Google Places API), Annict API                |
