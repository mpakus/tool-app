# frozen_string_literal: true

Rails.application.routes.draw do
  resources :tools do
    post :translate, on: :member
  end
  root 'tools#index'
end
