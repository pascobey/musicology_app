class CreateUsers < ActiveRecord::Migration[6.0]
  def up
    create_table :users do |t|
      t.integer :user_id
      t.string :client_id
      t.timestamps
    end
  end
  def down
    drop_table :users
  end
end
