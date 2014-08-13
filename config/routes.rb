FantasyGolf::Application.routes.draw do
  devise_for :users
  root to: "static_pages#welcome"
  resources :users, :only => [:show, :edit]
  resources :roster_memberships, :only => [:create, :destroy]
  resources :players, :only => [:index, :edit, :update, :destroy]

  resources :leagues do
    resources :league_memberships do
      post "droppable_players", to: 'league_memberships#droppable_players'
      post "update_score", to: 'league_memberships#update_score'
      get "score", to: 'league_memberships#score'
      get "season_scores", to: 'league_memberships#season_scores'
    end

    resources :seasons do
      resources :tournaments, :only => [:show, :new, :create]
    end
      
    resources :divisions
    resources :free_agent_offers
    resources :messages
    resource :bylaws
    resources :trades
    resources :tournaments
    get "admin", to: 'leagues#admin'
    post "/league_memberships/players", to: 'league_memberships#players'
  end

  resources :league_memberships, :only => [:new, :create]



  post "/roster_membership/admin_delete", to: "roster_memberships#admin_delete"
  get "demo", to:'users#demo'
end
