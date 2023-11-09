Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "locations#index"

  resources :forecasts, only: [:index, :create]

  namespace :api do
    namespace :v1 do
      resources :locations, only: [:show] do
        collection do
          get :suggestions
        end

        resources :forecasts
      end
    end
  end

end
