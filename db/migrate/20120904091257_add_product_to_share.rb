class AddProductToShare < ActiveRecord::Migration
  def change
    add_column :shares, :product_id, :integer
  end
end
