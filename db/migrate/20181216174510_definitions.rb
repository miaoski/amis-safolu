class Definitions < ActiveRecord::Migration[6.0]
  def up
    create_table :definitions do |t|
      t.integer :term_id
      t.timestamps
    end
  end

  def down
    drop_table :definitions
  end
end