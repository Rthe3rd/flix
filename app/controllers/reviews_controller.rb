class ReviewsController < ApplicationController

  before_action :require_signin 
  before_action :set_movie
  def index
    @reviews = @movie.reviews
  end
  def new
    @review = @movie.reviews.new
  end

  def create
    @review = @movie.reviews.new(review_params)
    @review.user = current_user
    if @review.save
      redirect_to movie_reviews_path @movie, notice: "Succesfully saved!"
    else 
      render :new, status: :unprocessable_entity
    end
    
  end

  def edit
    @movie = Movie.find(params[:movie_id])
    @review = @movie.reviews.find(params[:id])
  end  
  def update
    # Movie, records, check the params thing and then update
    @movie = Movie.find(params[:movie_id])
    @review = @movie.reviews.find(params[:id])
    if @review.update(review_params)
      redirect_to movie_reviews_path(@movie), notice: "Review Successfully Updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end  

  def destroy
    # movie, review_id
    @movie = Movie.find(params[:movie_id])
    @review = @movie.reviews.find(params[:id])
    @review.destroy!
    redirect_to movie_reviews_path(@movie), status: :see_other, alert: "Review Removed!"
  end

  private

  def review_params
    # Since only logged in users can add revies, we can remove names from the review_params
    #   as we already have it through the current_user application_controller method! 
    # params.require(:review).permit(:name, :stars, :comment)
    params.require(:review).permit(:stars, :comment)
  end

  private

  def set_movie
    @movie = Movie.find_by!(slug: params[:movie_id])
  end

end
