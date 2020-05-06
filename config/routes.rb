Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'

  resources :creatures, only: %i[index new create edit update destroy]
  resources :game_spaces, only: %i[show new create edit update destroy] do
    patch :live_toggle, on: :member
    get :guest_view
  end
  resources :encounters, only: %i[new create edit update destroy] do
    patch :run, on: :member
    patch :next_turn, on: :member
  end
end
