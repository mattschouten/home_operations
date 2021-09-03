Rails.application.routes.draw do
  root "chore_lists#index"
  get "/chorelists", to: "chore_lists#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
