FantasyGolf::Application.routes.draw do
  devise_for :users
  root to: "static_pages#welcome"
  resources :players, :only => [:index]
end
