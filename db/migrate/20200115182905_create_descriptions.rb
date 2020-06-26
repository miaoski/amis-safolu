class CreateDescriptions < ActiveRecord::Migration[5.0]
  def up
    create_table :descriptions do |t|
      t.integer :definition_id
      t.string  :content
      t.timestamps
    end

    create_table :examples do |t|
      t.integer :description_id
      t.string  :content
      t.timestamps
    end

    create_table :synonyms do |t|
      t.integer :description_id
      t.string  :content
      t.timestamps
    end
  end

  def down
    drop_table :descriptions
    drop_table :examples
    drop_table :synonyms
  end
end
