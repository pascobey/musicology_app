class CreatePlaylists < ActiveRecord::Migration[6.0]
  def up
    create_table :playlists do |t|
      t.integer :library_id
      t.string :spotify_unique
      t.string :playlist_image_url
      t.string :name
      t.timestamps
    end
  end
  def down 
    drop_table :playlists
  end
end
