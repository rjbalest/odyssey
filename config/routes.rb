Rails.application.routes.draw do
  resources :quotes
  resources :messages

  get '/query/:ticker', to: 'quotes#query', defaults: { format: :json }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
