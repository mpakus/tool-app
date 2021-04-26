# frozen_string_literal: true

Rails.application.routes.draw do
  resources :tools
  root 'tools#index'
end
