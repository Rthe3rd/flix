class FavoritesController < ApplicationController

  before_action :require_signin
  before_action :set_method

  def create
    # @movie = Movie.find(params[:movie_id])
    @movie = set_method
    @movie.favorites.create!(user: current_user)
    # or
    # @movie.fans << current_user
    redirect_to @movie
  end
  def destroy
    # Using the current_user route ensures that unlikes are by the signed in user
    current_user.favorites.find(params[:id]).destroy
    # redirect_to Movie.find(params[:movie_id])
    redirect_to set_method
  end


private
  def set_method
    @movie = Movie.find(params[:movie_id])
  end

end
