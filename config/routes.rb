Rails.application.routes.draw do
  resources :genres
  resources :users
  root "movies#index"
  
  get "up" => "rails/health#show", as: :rails_health_check
  
  # # Note that this is above the other actions
  # get "movies/new" => "movies#new", as: "new_movie"
  
  # # verb "url" => "name_of_controller#name_of_action"
  # get "movies" => "movies#index" 
  # # note that the movies for the CONTROLLER is pluralized
  # get "movie/:id" => "movies#show", as: "movie"
  
  # get "movies/:id/edit" => "movies#edit", as: "edit_movie"
  
  # # we do not need to generate links to the update action as the form will automatically do this for us
  # #   i.e. no as: "update_movie"
  # patch "movie/:id" => "movies#update"
  
  get "movies/filter/:filter" => "movies#index", as: :filtered_movies
  get "genres/:genre" => "movies#show", as: :movies_by_genre

  resources :movies do 
    resources :reviews
    resources :favorites, only: [:create, :destroy]
  end

  resource :session, only: [:new, :create, :destroy]
  # so that we can go to natural /"signin" for a sign in page
  get "signin" => "sessions#new" 


  # so that we can go to natural /"signup" for a sign up page
  get "signup" => "users#new" 

end
