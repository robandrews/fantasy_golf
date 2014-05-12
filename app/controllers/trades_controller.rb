class TradesController < ApplicationController
  def create
    @league = League.friendly.find(params[:league_id])
    @league_membership = LeagueMembership.find_by_user_id_and_league_id(current_user.id, @league.id)
    trade = Trade.new(:proposer_id => @league_membership.id, :proposee_id => params[:tradee_id])
    t1, t2 = trade.trade_groups.build([{:league_membership_id => @league_membership.id}, {:league_membership_id => params[:tradee_id]}])
    params[:trader].each{|player_id| t1.trade_group_memberships.build(:player_id => player_id)}
    params[:tradee].each{|player_id| t2.trade_group_memberships.build(:player_id => player_id)}
    
    if trade.save
      flash[:notice] = "Trade successfully submitted."
      render :json => trade, status: 200
    else
      flash[:errors] = "Trade submission failed"
      render :json => trade.errors.full_messages, status: :unprocessable_entity
    end
  end
  
  def index
    @league = League.friendly.find(params[:league_id])
    @league_memberships = LeagueMembership.all
    @league_membership = LeagueMembership.find_by_user_id_and_league_id(current_user.id, @league.id)
    @trades = Trade.where(:pending => true)
  end
  
  def update
    @trade = Trade.find(params[:id])
    p params
    Trade.transaction do      
      if @trade.update_attributes(:accepted => params[:accepted],
                                  :pending => params[:pending])
        @trade.execute if @trade.accepted
        flash[:notice] = "You #{@trade.accepted ? "accepted" : "denied"} trade."
        render :json => @trade, status: 200
      else
        flash[:errors] = "Trade submission failed"
        render :json => @trade.errors.full_messages, status: :unprocessable_entity
      end
    end
  end
end
