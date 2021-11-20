class ApplicationController < ActionController::Base
  # helper_method :current_user_session, :current_user
  before_action :authenticate_user!
  before_action :set_paths_in_session

private
  def set_paths_in_session
    session[:previous_path_in_session] = session[:current_path_in_session]
    session[:current_path_in_session] = request.path
  end

  def previous_path
    session[:previous_path_in_session]
  end
end
