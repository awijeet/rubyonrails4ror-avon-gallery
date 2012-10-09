class Share < ActiveRecord::Base
  # share mean when you send them stuffs as virtual gift
  belongs_to :user
  attr_accessible :friend_id, :user_id, :product_id
  validates_presence_of :friend_id
  
  validate :unique_share, :on => :create
  
  def unique_share
    share = Share.find_by_user_id_and_product_id_and_friend_id( user_id, product_id, friend_id)
    if share.nil?
       #errors.add(:product_id, "it has already been gifted")
    else
      errors.add(:product_id, "it has already been gifted")
    end

  end
           
end
