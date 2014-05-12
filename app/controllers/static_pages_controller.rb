class StaticPagesController < ApplicationController
  before_action :authenticate_user!, :only => [:bylaws]
  def welcome
  end
  
  def bylaws
  end
end
