class MessagesController < ApplicationController

  def index
    @league = League.friendly.find(params[:league_id])
    @messages = Message.where(:league_id => @league.id, :parent_id => 0).includes(:replies).reverse
    @league_membership = LeagueMembership.find_by_user_id_and_league_id(current_user.id, @league.id)
  end

  def new
    @league = League.friendly.find(params[:league_id])
  end

  def create
    @league = League.friendly.find(params[:league_id])
    @message = Message.new(message_params)
    @message.league_id = @league.id
    @message.sender_id = LeagueMembership.find_by_user_id_and_league_id(current_user.id, @league.id).id
    @message.sender_name = current_user.name
    @message.parent_id = 0 if @message.parent_id.nil?

    if @message.save
      if @message.parent_id == 0
        redirect_to league_message_url(params[:league_id], @message)
      else
        redirect_to league_message_url(:league_id => params[:league_id], :id => @message.parent_id)
      end
    else
      flash[:alert] = "Message failed to save"
      redirect_to new_league_message_url(params[:league_id])
    end
  end

  def show
    @league = League.friendly.find(params[:league_id])
    @message = Message.find(params[:id])
    @league_membership = LeagueMembership.find_by_user_id_and_league_id(current_user.id, @league.id)
  end

  protected
  def message_params
    params.require(:message).permit(:subject, :body, :parent_id)
  end
end
