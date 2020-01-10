class CreateTerms < ActiveRecord::Migration[6.0]
  def up
    create_table :terms do |t|
      t.string  :name
      t.integer :stem_id
      t.timestamps
    end

    add_index :terms, :stem_id
  end

  def down
    drop_table :terms
  end
end
