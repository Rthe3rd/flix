class SessionsController < ApplicationController

  def new
    @session
  end

  def create
    user = User.find_by(email: params[:email_or_username]) || User.find_by(username: params[:email_or_username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      # redirect users to the :inteded_url and if not, send it to them to their profile by simply using the user ActiveRecord instance
      redirect_to session[:intended_url] || user, notice: "Welcome back #{user.name}!"
      # the re_direct isn't ran until the action "falls through" so the proceeding line which clears the session[:intended_url]
      session[:intended_url] = nil
    else
      flash.now[:alert] = "Invalid email/password combination"
      render :new, status: :unprocessable_entity 
    end 
  end


  def destroy
    session[:user_id] = nil
    # OR 
    # session[:user_id] = nil
    redirect_to movies_path, status: :see_other, notice: "You are now signed out"
  end

end
