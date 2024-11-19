class SessionsController < ApplicationController

  def new
    @session
  end


  def create
  
  user = User.find_by(email: params[:email_or_username]) || User.find_by(username: params[:email_or_username])
  if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user, notice: "Welcome back #{user.name}!"
    else
      flash.now[:alert] = "Invalid email/password combination"
      render :new, status: :unprocessable_entity 
    end 

    email = params[:email]
    password = params[:password]
    
  end


  def destroy
    reset_session
    # OR 
    # session[:user_id] = nil
    redirect_to movies_path, status: :see_other, notice: "You are now signed out"
  end

end
