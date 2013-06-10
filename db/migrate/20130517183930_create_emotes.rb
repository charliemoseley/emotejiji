class CreateEmotes < ActiveRecord::Migration
  def change
    create_table :emotes, id: :uuid do |t|
      t.string  :text,            null: false
      t.text    :description
      t.integer :text_rows,       null: false
      t.integer :max_length,      null: false
      t.integer :display_rows,    null: false
      t.integer :display_columns, null: false
      t.hstore  :tags,            null: false, default: ''
      t.timestamps
    end

    add_index :emotes, :text
    add_index :emotes, :tags, using: 'gin'
  end
end