class CreateTracks < ActiveRecord::Migration[6.0]
  def up
    create_table :tracks do |t|
      t.integer :library_id
      t.json :tracks_json
      t.timestamps
    end
  end
  def down
    drop_table :tracks
  end
end
