Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'

  resources :creatures, only: %i[index new create edit update destroy]
  resources :game_spaces, only: %i[show new create edit update destroy] do
    patch :live_toggle, on: :member
  end
end
