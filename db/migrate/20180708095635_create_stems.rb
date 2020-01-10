class CreateStems < ActiveRecord::Migration[6.0]
  def up
    create_table :stems do |t|
      t.string :name
      t.timestamps
    end
  end

  def down
    drop_table :stems
  end
end
