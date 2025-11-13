Rails.application.routes.draw do
  resources :tasks
  patch "tasks/reorder", to: "tasks#reorder"

  get "up" => "rails/health#show", as: :rails_health_check
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  root "tasks#index"
end
