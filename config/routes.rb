Rails.application.routes.draw do
  root 'events#index'

  namespace 'api' do
    put :events, to: 'events#create'
  end

  constraints subdomain: 'api' do
    put :events, to: 'events#create'
  end
end
