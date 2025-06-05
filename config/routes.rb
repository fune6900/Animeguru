require 'sidekiq/web'

Rails.application.routes.draw do
  # sidekiqのWeb UIを `/sidekiq` パスでマウント
  Sidekiq::Web.use(Rack::Auth::Basic) do |user_id, password|
    [ user_id, password ] == [ ENV["SIDEKIQ_BASIC_ID"], ENV["SIDEKIQ_BASIC_PASSWORD"] ]
  end
  mount Sidekiq::Web, at: "/sidekiq"

  # ルートパス（ホーム画面）
  root "homes#index"

  # Devise のユーザー認証ルート
  devise_for :users, controllers: {
  registrations: "users/registrations",
  sessions: "users/sessions",
  passwords: "users/passwords",
  omniauth_callbacks: "users/omniauth_callbacks"
  }

  # ユーザープロフィールのルーティング
  get "profile", to: "users#profile", as: :profile
  # 他人用プロフィール
  resources :users, only: [ :show ]

  # 聖地メモの CRUD ルーティング
  resources :seichi_memos, only: [ :index, :new, :create, :show, :edit, :update, :destroy ] do
    resources :comments, only: %i[create destroy edit update]
    resources :likes, only: %i[create destroy], shallow: true
    collection do
      match :update_session, via: [ :post, :patch ] # ステップごとのデータをセッションに保存
      get :confirm # 確認画面でセッション情報を反映する
      get :bookmarks # ブックマークした聖地メモを表示する
      get :autocomplete # オートコンプリート機能
      post :upload_image # 画像アップロード時に即座にキャッシュ処理を行う
    end
  end

  resources :bookmarks, only: %i[create destroy]
  resources :columns, only: %i[index]

  # Health check ルート（アップタイムモニタリング用）
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA サポート用の動的ルート
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # APIエンドポイントのルーティングを追加
  namespace :api do
    get "seichi_search", to: "seichi_search#index"
    get "anime_search", to: "anime_search#index"
  end

  # 利用規約とプライバシーポリシー
  get "privacy_policy" => "homes#privacy_policy", as: :privacy_policy
  get "terms_of_service" => "homes#terms_of_service", as: :terms_of_service

  # ブラウザ上で送信メールの履歴一覧を確認できるようにするための設定
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
