Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'

  resources :game_spaces, only: %i[show new create edit update destroy]
end
