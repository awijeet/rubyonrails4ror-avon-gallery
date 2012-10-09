class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.string :friend_id
      t.references :user

      t.timestamps
    end
    add_index :shares, :user_id
  end
end
