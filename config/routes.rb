# frozen_string_literal: true

Rails.application.routes.draw do
  resources :publishing_houses
  resources :authors
  resources :books
  get '/search', to: 'search#show', as: :search
  post '/github', to: 'github_webhooks#webhook', as: :github_webhook
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
