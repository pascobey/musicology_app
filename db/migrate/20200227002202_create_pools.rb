class CreatePools < ActiveRecord::Migration[6.0]
  def up
    create_table :pools do |t|
      t.integer :pool_id
      t.string :pool_name
      t.string :pool_unique_digest
      t.timestamps
    end
  end
  def down
    drop_table :pools
  end
end
