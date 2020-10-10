class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show, :destroy]

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end

  def new
    @user = User.new
  end

  def edit
    if current_user == @user
      @user = User.find(params[:id])
    else
      flash[:danger] = "You cannot update this user because you are not the person you deleted."
      redirect_to users_path
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Word Life #{@user.username}"
      redirect_to articles_path
    else
      render :new; end
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Your account was updated successfully"
      redirect_to articles_path
    else
      render :edit; end
  end

  def show
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  def destroy
    if current_user == @user
      @user.destroy
      flash[:success] = "User was deleted"
      redirect_to users_path
    else
      flash[:danger] = "You cannot delete this user because you are not the person you deleted."
      redirect_to users_path
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

end
