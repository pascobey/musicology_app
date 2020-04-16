class CreateArtists < ActiveRecord::Migration[6.0]
  def up
    create_table :artists do |t|
      t.string :artist_spotify_unique
      t.integer :library_id
      t.string :name
      t.string :spotify_open_url
      t.string :spotify_api_url
      t.integer :follower_count
      t.string :genres
      t.string :artist_image_url
      t.integer :spotify_popularity_index
      t.timestamps
    end
  end
  def down 
    drop_table :artists
  end
end
