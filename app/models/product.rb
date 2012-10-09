class Product < ActiveRecord::Base
  attr_accessible :name, :image, :description
  if Rails.env.production?
	  has_attached_file :image, 
	                    :styles => { :medium => "186x187>", :thumb => "100x100>" },
	                    :storage => :s3,
	                    :bucket => 'india.liveoncampus.com',
	                    :s3_credentials => {
	                      :access_key_id => 'AKIAJJJOHNZHTUACANSQ',
	                      :secret_access_key => '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'
	                    }
   else
   		has_attached_file :image, 
	                    :styles => { :medium => "186x187>", :thumb => "100x100>" }
   end	                    
end
