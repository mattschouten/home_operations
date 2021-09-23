class UsersController < ApplicationController
  skip_before_action :require_user, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params.to_h)
    @user.active = true
    @user.approved = true
    @user.confirmed = true
    # Someday there might be a need to be a bit more sophisticated, e.g., email confirmation

    @user.login = @user.email unless @user.login

    if @user.save
      redirect_to root_url
    else
      render :action => :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :remember_me)
  end
end