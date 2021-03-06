class CreateUsers < ActiveRecord::Migration[6.0]
  def up
    create_table :users do |t|
      t.string :user_spotify_unique
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
