class User < ActiveRecord::Base
  attr_accessible :email, :fbid, :oauth_access_token

  def total_share
  	Share.where(:user_id => self.id).count
  end

  def total_tag
	Tag.where(:user_id => self.id).count  	
  end	

  def final_point
  	self.total_tag+self.total_share
  end	
end
