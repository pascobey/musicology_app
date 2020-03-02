class CreateLibraries < ActiveRecord::Migration[6.0]
  def up
    create_table :libraries do |t|
      t.integer :user_id
      t.timestamps
    end
  end
  def down 
    drop_table :libraries
  end
end
