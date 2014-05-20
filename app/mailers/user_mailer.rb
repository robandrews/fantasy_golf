class UserMailer < ActionMailer::Base
  default from: "comissioner@bushwood.us"
  
  def weekly_summary_email(user, league, player_scores)
    @user = user
    @league = league
    @player_scores = player_scores
    mail(to: user.email, subject: "Weekly Summary for #{league.name}")
  end
  
  def trade_proposee(trade, league)
    @trade = trade
    @league = league
    @proposee = LeagueMembership.find(trade.proposee_id)
    @proposer = LeagueMembership.find(trade.proposer_id)
    user = User.find(@proposee.user_id)
    mail(to: user.email, subject: "Trade Proposed by #{@proposer.name}")
  end  
end
