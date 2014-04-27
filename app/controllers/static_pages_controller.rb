class StaticPagesController < ApplicationController
  before_action :authenticate_user!
  def welcome
  end
  
  def bylaws
  end
end
