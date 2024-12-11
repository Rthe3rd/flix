class FavoritesController < ApplicationController

  before_action :require_signin
  before_action :set_movie

  def create
    # @movie = Movie.find(params[:movie_id])
    @movie = set_movie
    @movie.favorites.create!(user: current_user)
    # or
    # @movie.fans << current_user
    redirect_to @movie
  end
  def destroy
    # Using the current_user route ensures that unlikes are by the signed in user
    current_user.favorites.find(params[:id]).destroy
    # redirect_to Movie.find(params[:movie_id])
    redirect_to set_movie
  end

private
  # def set_method
  #   @movie = Movie.find(params[:movie_id])
  # end

  def set_movie
    @movie = Movie.find_by(slug: params[:movie_id])
  end

end
