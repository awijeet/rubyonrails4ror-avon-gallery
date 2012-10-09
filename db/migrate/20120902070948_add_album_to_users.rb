class AddAlbumToUsers < ActiveRecord::Migration
  def change
    add_column :users, :album_id, :string
  end
end
