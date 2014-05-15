class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def demo
    sign_in(:user, User.find_by_email("guest@gmail.com"))
    redirect_to root_url
  end
end
