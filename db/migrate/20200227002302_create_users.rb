class CreateUsers < ActiveRecord::Migration[6.0]
  def up
    create_table :users id: false do |t|
      t.string :user_id
      t.string :email
      t.string :account_url
      t.string :refresh_token
      t.timestamps
    end
  end
  def down
    drop_table :users
  end
end
