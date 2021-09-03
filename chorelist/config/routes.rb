Rails.application.routes.draw do
  root "chore_lists#index"

  resources :chore_lists do
    resources :chores
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
