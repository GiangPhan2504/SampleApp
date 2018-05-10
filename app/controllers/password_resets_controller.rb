class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "controller.password_reset.sent_email_reset_password"
      redirect_to root_url
    else
      flash.now[:danger] = t "controller.password_reset.email_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password,t("controller.password_reset.not_empty_password")
      render :edit
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = t "controller.password_reset.password_be_reset"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def load_user
    @user = User.find_by email: params[:email]
    unless @user
        flash[:warning] = t "title.not_found_user"
        redirect_to users_url
      end
  end

  def valid_user
    unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
      redirect_to root_url
    end
  end

   def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = t "controller.password_reset.password_be_expried"
      redirect_to new_password_reset_url
    end
  end
end
