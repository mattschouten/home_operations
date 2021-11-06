class ApplicationController < ActionController::Base
  # helper_method :current_user_session, :current_user
  before_action :authenticate_user!
end
