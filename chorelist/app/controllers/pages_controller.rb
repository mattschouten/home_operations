class PagesController < ApplicationController
    skip_before_action :require_user
end
