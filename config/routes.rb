Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               registration: 'register'
             }
  get 'logout', to: 'devise/sessions#destroy'

  root 'pages#index'

  get 'home', to: 'users#show'
  resources :projects, only: [:show, :new, :create] do
    post 'reset_token'
  end

  namespace 'api' do
    put :events, to: 'events#create'
  end

  constraints subdomain: 'api' do
    put :events, to: 'events#create'
  end
end
