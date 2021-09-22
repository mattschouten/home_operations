class UserController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params.to_h)
    if @user.save
      redirect_to root_url
    else
      render :action => :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:login, :password, :password_confirmation, :remember_me)
  end
end