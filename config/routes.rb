Rails.application.routes.draw do
  resources :games do
    resources :results, only: [:create, :destroy, :new]
    resources :ratings, only: [:index]
  end

  resources :players do
    resources :games, only: [:show], controller: 'player_games'
  end

  get '/dashboard' => 'dashboard#show', as: :dashboard
  root to: 'dashboard#show'

  scope '/api' do
    scope '/v1' do
      scope '/players' do
        post '/create'               => 'api_players#create'
        get  '/:id/'                 => 'api_players#show'
        post  '/email/'              => 'api_players#get_by_email'
        post  '/name/'               => 'api_players#get_by_name'
        get  '/:player_id/games/:id' => 'api_player_games#show'
      end
      scope '/games' do
        post '/:game_id/results/create' => 'api_results#create'
      end
    end
  end
end
