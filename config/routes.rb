Rails.application.routes.draw do
  namespace :api, default: { format: 'json' } do
    namespace :v1 do
      resources :games, only: [:create, :show]
    end
  end
end
