Rails.application.routes.draw do
  resources :users

  get "up" => "rails/health#show", as: :rails_health_check

  root "movies#index"
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

  resources :movies do 
    resources :reviews
  end

end
