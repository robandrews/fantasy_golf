class MessagesController < ApplicationController
  
  def index
    @league = League.friendly.find(params[:league_id])
    @messages = Message.where(:league_id => @league.id)
  end
  
  def new
    @league = League.friendly.find(params[:league_id])
  end
  
  def create
    @league = League.friendly.find(params[:league_id])
    @message = Message.new(message_params)
    @message.league_id = @league.id
    @message.sender_id = current_user.id
    @message.sender_name = current_user.name
    @message.parent_id = 0
    
    if @message.save
      flash[:notice] = "Message saved successfully"
      redirect_to league_messages_url(params[:league_id])
    else
      flash[:errors] = "Message failed to save"
      redirect_to new_league_message_url(params[:league_id])
    end
  end
  
  protected
  def message_params
    params.require(:message).permit(:subject, :body)
  end
end
