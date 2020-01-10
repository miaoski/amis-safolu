class Definitions < ActiveRecord::Migration[6.0]
  def up
    create_table :definitions do |t|
      t.integer :term_id
      t.string  :content
      t.timestamps
    end

    create_table :examples do |t|
      t.integer :definition_id
      t.string  :content
      t.timestamps
    end

    create_table :alternatives do |t|
      t.integer :definition_id
      t.string  :content
      t.timestamps
    end
  end

  def down
    drop_table :definitions
    drop_table :examples
    drop_table :alternatives
  end
end
