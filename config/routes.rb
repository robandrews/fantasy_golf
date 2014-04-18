FantasyGolf::Application.routes.draw do
  devise_for :users
  root to: "static_pages#welcome"
  resources :users, :only => [:show]
  resources :players, :only => [:index]
  resources :leagues do
    resources :divisions
  end
  resources :league_memberships, :only => [:new, :create]
  resources :tournaments
end