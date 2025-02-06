Rails.application.routes.draw do
  root "homes#index"

  devise_for :users, controllers: {
  registrations: "users/registrations",
  sessions: "users/sessions"
  }

  resources :seichi_memos, only: [:index]

  # Health check ルート（アップタイムモニタリング用）
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA サポート用の動的ルート
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
