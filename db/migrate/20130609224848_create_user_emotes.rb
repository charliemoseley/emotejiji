class CreateUserEmotes < ActiveRecord::Migration
  def change
    create_table :user_emotes do |t|
      t.string :kind,     null: false
      t.uuid   :user_id,  null: false
      t.uuid   :emote_id, null: false
      t.text   :tags,     array: true

      t.timestamps
    end

    add_index :user_emotes, [:kind, :user_id, :emote_id]
  end
end
