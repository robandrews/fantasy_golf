FantasyGolf::Application.routes.draw do
  devise_for :users
  root to: "static_pages#welcome"
  resources :users, :only => [:show]
  
  resources :roster_memberships, :only => [:destroy]
  
  
  resources :players, :only => [:index]
  resources :leagues do
    resources :divisions
    resources :users, :only => [:edit, :update]
    resources :free_agent_offers
    resources :messages
    get "bylaws"
  end
  
  resources :league_memberships, :only => [:new, :create]
  
  resources :seasons do
    resources :tournaments, :only => [:show]
  end
end