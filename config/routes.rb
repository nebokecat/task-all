Rails.application.routes.draw do
  get 'sessions/new'
  post 'sessions/create'
  delete 'sessions/destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :tasks
end
