class CreateLibraries < ActiveRecord::Migration[6.0]
  def up
    create_table :libraries do |t|
      t.string :user_id
      t.hstore :library_stratified
      t.timestamps
    end
  end
  def down 
    drop_table :libraries
  end
end
