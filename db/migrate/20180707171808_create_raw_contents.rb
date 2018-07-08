class CreateRawContents < ActiveRecord::Migration[5.0]
  def up
    create_table :raw_contents do |t|
      t.string  :key
      t.string  :value
      t.integer :term_id
      t.timestamps
    end

    add_index :raw_contents, :term_id
  end

  def down
    drop_table :raw_contents
  end
end
