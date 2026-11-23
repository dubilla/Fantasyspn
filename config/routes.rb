Rails.application.routes.draw do
  root 'posts#index'
  resources :posts, only: [:index, :show]
  resources :seasons, only: [:show]

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
