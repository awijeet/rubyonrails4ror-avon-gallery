class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :friend_id
      t.references :user

      t.timestamps
    end
    add_index :tags, :user_id
  end
end
