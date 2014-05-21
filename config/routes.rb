FantasyGolf::Application.routes.draw do
  devise_for :users
  root to: "static_pages#welcome"
  resources :users, :only => [:show, :edit]
  resources :roster_memberships, :only => [:destroy]
  resources :players, :only => [:index, :edit, :update, :destroy]
  
  resources :leagues do
    resources :divisions
    resources :league_memberships do
      get "players", to: 'league_memberships#players'
    end
    resources :free_agent_offers
    resources :messages
    resource :bylaws
    resources :trades
  end
  
  resources :league_memberships, :only => [:new, :create]
  
  resources :seasons do
    resources :tournaments, :only => [:show, :new, :create]
  end
  
  get "demo", to:'users#demo'
end