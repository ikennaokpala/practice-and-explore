Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#index'

  concern :v1_api_routes_concern do
    resources :ideas, only: %i[create destroy update index], module: :v1
    resources :users, only: %i[create], module: :v1
    resource :access_tokens, path: 'access-tokens', only: %i[create destroy], module: :v1 do
      collection { post :refresh, to: 'access_tokens#update' }
    end
    resource :me, only: %i[show], module: :v1
  end

  concerns :v1_api_routes_concern
  scope(path: :v1, as: :v1) { concerns :v1_api_routes_concern }
end
