FantasyGolf::Application.routes.draw do
  devise_for :users
  root to: "static_pages#welcome"
  resources :users, :only => [:show]
  
  resources :roster_memberships, :only => [:destroy]
  
  
  resources :players, :only => [:index]
  resources :leagues do
    resources :divisions
    resources :league_memberships do
      get "players", to: 'league_memberships#players'
    end
    resources :free_agent_offers
    resources :messages
    resources :bylaws
    resources :trades
  end
  
  resources :league_memberships, :only => [:new, :create]
  
  resources :seasons do
    resources :tournaments, :only => [:show]
  end
end