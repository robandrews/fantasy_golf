# == Schema Information
#
# Table name: trades
#
#  id          :integer          not null, primary key
#  proposer_id :integer
#  proposee_id :integer
#  accepted    :boolean          default(FALSE)
#  pending     :boolean          default(TRUE)
#  created_at  :datetime
#  updated_at  :datetime
#

class Trade < ActiveRecord::Base
  validates :proposer_id, :proposee_id, :presence => true
  
  belongs_to :proposer,
  :class_name => "LeagueMembership",
  :foreign_key => :proposer_id,
  :primary_key => :id
  
  belongs_to :proposee,
  :class_name => "LeagueMembership",
  :foreign_key => :proposee_id,
  :primary_key => :id
  
  has_many :trade_groups
  
  # not done yet!!
  def execute
    Trade.transaction do
      traders = 
        [LeagueMembership.find(self.proposer_id), LeagueMembership.find(self.proposee_id)] 
      other_id = {traders[0] => traders[1], traders[1] => traders[0]}
      traders.each do |trader|
        puts "Trader: #{trader}"
        group = self.trade_groups.select{|group| group.league_membership_id == trader.id}.first
        puts "Player group: #{group}"
        player_roster_memberships = trader.roster_memberships.select{|rm| group.players.map{|p| p.id}.include?(rm.player_id)}
        puts "Players roster memberships #{player_roster_memberships}"
        player_roster_memberships.each do |rm|
          p rm.update_attributes!(:league_membership_id => other_id[trader].id)
        end
      end      
      self.update_attributes(:accepted => true, :pending => false)
    end
    
  end
end
