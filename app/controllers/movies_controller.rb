class MoviesController < ApplicationController

  before_action :require_signin, except: [:show, :index]
  before_action :require_admin, except: [:show, :index]
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  

  def index
    # @movies = Movie.all
    case params[:filter] 
      when "upcoming"
        @movies = Movie.upcoming
      when "recent"
        @movies = Movie.recent
      when "flops"
        @movies = Movie.flops
      when "hits"
        @movies = Movie.hits
      else
        @movies = Movie.released
    end
  end

  def new
    @movie = Movie.new
  end

  def create
    # Note that this @movie instance variable is NOT the same @movie instance variable as the one that sets up the form
    # This is a new movie instance that uses the params sent from the form
    # Instance variables go bye bye once an action completes
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to @movie, notice: "Movie Successfully Created!"
    else
      # unprocessable_entity is an alias 422 HTTP status code
      # We don't want to lose valid pieces of data, that is why we render vs. redirect 
      # Note you render to the "new" action, which in turns render the new page/template
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @review = @movie.reviews.new
    @fans = @movie.fans
    @genres = @movie.genres.order(:name)
    if current_user
      @favorite = current_user.favorites.find_by(movie_id: @movie.id)
    end
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def update
    @movie = Movie.find(params[:id])
    if @movie.update(movie_params)
      # Both of the following are valid to re-direct to the show page for edited record
      # redirect_to movie_path(movie)
      redirect_to @movie, notice: "Movie Successfully Updated"
      # Note you render the edit action, taking you to the edit page
    else 
      render :edit, status: :unprocessable_entity      
    end
    
  end
  
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy!
    redirect_to movies_url, status: :see_other, alert: "Movie Successfully Created!"

    # Example of a custom flash notice
      # redirect_to movies_url, status: :see_other,
      #   danger: "I'm sorry, Dave, I'm afraid I can't do that!"

  end


  private
    def movie_params
      params.require(:movie).permit(:title, :description, :rating, :released_on, :total_gross, :director, :duration, :image_file_name, genre_ids: [])
    end

    def set_movie
      @movie = Movie.find_by!(slug: params[:id])
    end 
end
