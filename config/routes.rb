FantasyGolf::Application.routes.draw do
  devise_for :users
  root to: "static_pages#welcome"
  resources :users, :only => [:show, :edit]
  resources :roster_memberships, :only => [:create, :destroy]
  resources :players, :only => [:index, :edit, :update, :destroy]

  resources :leagues do
    resources :divisions
    resources :league_memberships do
      post "players", to: 'league_memberships#players'
      post "droppable_players", to: 'league_memberships#droppable_players'
      post "update_score", to: 'league_memberships#update_score'
      get "score", to: 'league_memberships#score'
    end
    resources :free_agent_offers
    resources :messages
    resource :bylaws
    resources :trades
    get "admin", to: 'leagues#admin'
  end

  resources :league_memberships, :only => [:new, :create]

  resources :seasons do
    resources :tournaments, :only => [:show, :new, :create]
  end
  post "/roster_membership/admin_delete", to: "roster_memberships#admin_delete"
  get "demo", to:'users#demo'
end
