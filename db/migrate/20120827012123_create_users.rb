class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :fbid
      t.string :email
      t.string :oauth_access_token

      t.timestamps
    end
  end
end
