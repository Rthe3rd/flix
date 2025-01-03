class UsersController < ApplicationController

  before_action :require_signin, except: [:new, :create]
  before_action :set_username, only: [:show, :edit, :update]
  before_action :require_correct_user, only: [:edit, :update]
  before_action :require_admin, only: [:destroy]

  def index
    # @users = User.all
    @users = User.not_admins
  end

  def show
    # @user = User.find(params[:id])
    @reviews = @user.reviews
    @favorite_movies = @user.favorite_movies
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: "Thanks for signing up!" 
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # Since require_correct_user is run before :edit, :update and :destroy, defining/fetching/querying a user in the method is not needed
    # @user = User.find(params[:id])
  end
  
  def update
    # Since require_correct_user is run before :edit, :update and :destroy, defining/fetching/querying a user in the method is not needed
    # @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, notice: "Thanks for updating!"
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    # Since require_correct_user is run before :edit, :update and :destroy, defining/fetching/querying a user in the method is not needed
    # @user = User.find(params[:id])
    @user = User.find(session[:user_id])
    @user.destroy!
    # OR 
    # Since only Admins can delete, we do not remove the session
    # session[:user_id] = nil
    redirect_to users_url, status: :see_other, alert: "Profile deleted"
  end

private
  def user_params
    params.require(:user).
      permit(:name, :email, :password, :password_confirmation, :username)
  end

  def require_correct_user
    # @user finds the user based on the params hash which is different than the session hash in which current_user? makes a comparision to
    # Since we have moved the set_username call_back before the require_correct_user callback, we do not specficy the user here
    # @user = User.find(params[:id])
    redirect_to movies_url, status: :see_other unless current_user?(@user)
    # this line roughly translates to: @current_user ||= User.find(session[:user_id]) if session[:user_id] == @user
  end

  def set_username
    @user = User.find_by!(username: params[:id])
    # @user = User.find_by!(slug: params[:id])
  end

  # def set_movie
  #   @movie = Movie.find_by!(slug: params[:id])
  # end 

end
