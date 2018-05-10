class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create show)
  before_action :admin_user, only: %i(destroy)
  before_action :find_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)

  def index
    @users = User.get_all_user params
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "controller.users.create_account_successfully"
      redirect_to @user
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "controller.users.update_successfully"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t("controller.users.delete")
    else
      flash[:warning] = t("controller.users.delete_err")
    end
    redirect_to users_url
  end

  private
    def user_params
      params.require :user
      .permit :name, :email, :password,:password_confirmation
    end

    def logged_in_user
      unless logged_in?
        flash[:danger] = t "controller.users.login_now"
        redirect_to login_url
      end
    end

    def correct_user; end

    def admin_user
      redirect_to root_url unless current_user.admin?
    end

    def find_user
      @user = User.find_by id: params[:id]
      unless @user
        flash[:warning] = t "title.not_found_user"
        redirect_to users_url
      end
    end

end
