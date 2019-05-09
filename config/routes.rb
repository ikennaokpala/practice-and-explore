Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope module: :v1, path: :v1, as: :v1 do  
    resources :ideas, only: %i[create destroy update index]
    resources :users, only: %i[create]
    resource :me, only: %i[show]
  end
end
