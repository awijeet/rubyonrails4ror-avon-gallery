class AddProductToTag < ActiveRecord::Migration
  def change
    add_column :tags, :product_id, :integer
  end
end
