Rails.application.routes.draw do
  # ルートパス（ホーム画面）
  root "homes#index"

  # Devise のユーザー認証ルート
  devise_for :users, controllers: {
  registrations: "users/registrations",
  sessions: "users/sessions"
  }

  # 聖地メモの CRUD ルーティング
  resources :seichi_memos, only: [ :index, :new, :create, :show, :edit, :update, :destroy ]

  # Health check ルート（アップタイムモニタリング用）
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA サポート用の動的ルート
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Annict APIエンドポイントのルーティングを追加
  namespace :api do
    get "anime_search", to: "anime_search#index"
  end
end
