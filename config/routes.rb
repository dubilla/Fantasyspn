Rails.application.routes.draw do
  root 'posts#index'
  resources :posts, only: [:index, :show]

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
