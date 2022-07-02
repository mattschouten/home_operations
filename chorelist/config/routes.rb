Rails.application.routes.draw do
  resources :families
  root "pages#index"

  resources :chore_lists do
    resources :chores

    member do
      post 'carryover'
    end
  end
  get '/today', to: "chore_lists#today", as: :today

  resources :everyday_chores

  devise_for :users, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout', registration: 'register' }

  #delete '/sign_out', to: 'user_sessions#destroy', as: :sign_out
  #delete '/sign_in', to: 'user_sessions#new', as: :sign_in

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
