# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :v1, constraints: { format: :json } do
    resources :sessions, only: [:create]
    resources :restaurants
  end
end
