class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: :uuid  do |t|
      t.string :email
      t.string :username,        null: false
      t.string :password_digest, null: false
      t.string :remember_token,  null: false

      t.timestamps
    end

    add_index :users, :email
    add_index :users, :username, unique: true
  end
end
