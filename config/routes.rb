Rails.application.routes.draw do
  # ルートパス（ホーム画面）
  root "homes#index"

  # Devise のユーザー認証ルート
  devise_for :users, controllers: {
  registrations: "users/registrations",
  sessions: "users/sessions"
  }

  # ユーザープロフィールの CRUD ルーティング
  get "profile", to: "users#show"

  # 聖地メモの CRUD ルーティング
  resources :seichi_memos, only: [ :index, :new, :create, :show, :edit, :update, :destroy ] do
    resources :comments, only: %i[create], shallow: true
    resources :likes, only: %i[create destroy], shallow: true
    collection do
      match :update_session, via: [ :post, :patch ] # ステップごとのデータをセッションに保存
      get :prepare_confirm # 確認画面でセッション情報を反映する
      get :bookmarks # ブックマークした聖地メモを表示する
    end
  end

  resources :bookmarks, only: %i[create destroy]

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
end
