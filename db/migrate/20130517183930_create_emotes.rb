class CreateEmotes < ActiveRecord::Migration
  def change
    create_table :emotes, id: :uuid do |t|
      t.string  :text,                null: false
      t.text    :description
      t.integer :text_rows,           null: false
      t.integer :longest_line_length, null: false
      t.text    :tags, array: true
      t.timestamps
    end

    add_index :emotes, :text_rows
    add_index :emotes, :tags, using: 'gin'
  end
end
