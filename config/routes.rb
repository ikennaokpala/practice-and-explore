Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope module: :v1, path: :v1, as: :v1 do  
    resources :ideas, only: %i[create destroy update index]
    resources :users, only: %i[create]
    resource :access_tokens, path: 'access-tokens', only: %i[create destroy] do
      collection { post :refresh, to: 'access_tokens#update' }
    end
    resource :me, only: %i[show]
  end
end
