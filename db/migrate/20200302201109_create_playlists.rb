class CreatePlaylists < ActiveRecord::Migration[6.0]
  def up
    create_table :playlists do |t|
      t.integer :library_id
      t.integer :spotify_unique
      t.string :name
      t.timestamps
    end
  end
  def down 
    drop_table :playlists
  end
end
