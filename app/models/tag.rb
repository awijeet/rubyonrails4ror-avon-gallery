class Tag < ActiveRecord::Base
    belongs_to :user
    attr_accessible :friend_id, :user_id, :product_id
    validate :unique_tag, :on => :create
  
  def unique_tag
    tag = Tag.find_by_user_id_and_product_id_and_friend_id( user_id, product_id, friend_id)
    if tag.nil?
      #errors.add(:product_id, "it has already been gifted")
    else
      errors.add(:product_id, "it has already been tagged")
    end

  end
  
  
end
