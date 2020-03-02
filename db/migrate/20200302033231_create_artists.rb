class CreateArtists < ActiveRecord::Migration[6.0]
  def up
    create_table :artists do |t|
      t.integer :library_id
      t.string :name
      t.timestamps
    end
  end
  def down 
    drop_table :artists
  end
end
