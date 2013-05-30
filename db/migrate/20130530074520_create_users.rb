class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: :uuid  do |t|
      t.string :email,    null: false
      t.string :username, null: false
      t.string :password, null: false

      t.timestamps
    end

    add_index :users, :email,    unique: true
    add_index :users, :username, unique: true
    add_index :users, :password
  end
end
