class AddLinkedContentToExampleAndSynonym < ActiveRecord::Migration[6.0]
  def up
    add_column :examples, :linked_content, :string, limit: 500
    add_column :synonyms, :linked_content, :string
  end

  def down
    remove_column :examples, :linked_content, :string, limit: 500
    remove_column :synonyms, :linked_content, :string
  end
end
