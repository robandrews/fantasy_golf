class StaticPagesController < ApplicationController
  before_action :authenticate_user!, :only => [:bylaws]
  def welcome
    redirect_to user_url(current_user) if user_signed_in?
  end
  
  def bylaws
  end
end
