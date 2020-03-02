class CreateTracks < ActiveRecord::Migration[6.0]
  def up
    create_table :tracks do |t|
      t.integer :playlist_id
      t.string :artists_names
      t.string :track_name
      t.string :album_name
      t.timestamps
    end
  end
  def down
    drop_table :tracks
  end
end
