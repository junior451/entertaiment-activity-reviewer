Rails.application.routes.draw do
  get '/movies' => 'movies#index'
  get '/movie/:id' => 'movies#show'
  post '/movies' => 'movies#create'
  put '/movies/:id' => 'movies#update'
  delete '/movies/:id' => 'movies#destroy'
end
