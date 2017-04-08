Rails.application.routes.draw do
  get '/template', to: redirect('template/template.html')
end
