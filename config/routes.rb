Rails.application.routes.draw do
  namespace :api, default: { format: 'json' } do
    namespace :v1 do
      resources :games, only: [:create, :show] do
        resources :players, only: [] do
          resources :frames, only: [] do
            resource :roll, only: [:create]
          end
        end
      end
    end
  end
end
