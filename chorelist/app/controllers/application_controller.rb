class ApplicationController < ActionController::Base
    helper_method :current_user_session, :current_user
    before_action :require_user

    private
      def current_user_session
        return @current_user_session if defined?(@current_user_session)
        @current_user_session = UserSession.find
      end

      def current_user
        return @current_user if defined?(@current_user)
        @current_user = current_user_session && current_user_session.user
      end

    def require_user
      unless current_user
        flash[:error] = "You must be logged in to access this page"
        redirect_to root_url
        return false
      end
    end

    protected
        def handle_unverified_request
            # raise an exception
            fail ActionController::InvalidAuthenticityToken
            # or destroy session, redirect
            if current_user_session
            current_user_session.destroy
            end
            redirect_to root_url
        end
end
