class CreateTracks < ActiveRecord::Migration[6.0]
  def up
    create_table :tracks do |t|
      t.string :artist_id
      t.string :track_name
      t.string :album_name
      t.timestamps
    end
  end
  def down
    drop_table :tracks
  end
end
