Rails.application.routes.draw do

  root 'contacts#index'

  resource :contacts, except: [:destroy, :edit, :update]
  resources :photos, only: [:index, :create]

  get '/template', to: redirect('template/template.html')
end
