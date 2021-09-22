Rails.application.routes.draw do
  root "chore_lists#index"

  resources :chore_lists do
    resources :chores
  end

  resources :users #, only [:new, :create]
  resource :user_sessions #, only [:create, :destroy]

  delete '/sign_out', to: 'user_sessions#destroy', as: :sign_out
  delete '/sign_in', to: 'user_sessions#new', as: :sign_in

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
