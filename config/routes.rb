Rails.application.routes.draw do

  root 'contacts#index'

  resource :contacts, except: [:destroy, :edit, :update]

  get '/template', to: redirect('template/template.html')
end
