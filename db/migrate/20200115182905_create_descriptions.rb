class CreateDescriptions < ActiveRecord::Migration[5.0]
  def up
    create_table :descriptions do |t|
      t.integer :definition_id
      t.string  :content
      t.timestamps
    end
  end

  def down
    drop_table :descriptions
  end
end
