class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
     @users = User.select(:id, :name, :email).paginate(page: params[:page]).limit(Settings.users_per_page).select(:email).order("name ASC")
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "controller.users.check_mail_create_user"
      redirect_to root_url
    else
      render :new
    end
  end

  def find_id
    User.find_by id: params[:id]
  end

  def show
    @user = find_id
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def edit
    @user = find_id
  end

  def update
    @user = find_id
    if @user.update_attributes(user_params)
      flash[:success] = t "controller.users.update_successfully"
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t "controller.users.delete"
    redirect_to users_url
  end

  def following
    @title = t "controller.users.following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = t "controller.users.followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password,:password_confirmation)
    end

    def correct_user
      @user = find_id
      redirect_to root_url unless current_user?(@user)
    end

    def admin_user
        redirect_to root_url unless current_user.admin?
    end

end
