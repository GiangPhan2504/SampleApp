class SessionsController < ApplicationController

  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == Settings.remember_session ?
      remember(user) : forget(user)
      redirect_to user
    else
      flash.now[:danger] = t "title.password_wrong"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
