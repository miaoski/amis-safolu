class AddTermTypeToSynonym < ActiveRecord::Migration[6.0]
  def up
    add_column :synonyms, :term_type, :string, limit: 5
  end

  def down
    remove_column :synonyms, :term_type, :string, limit: 5
  end
end
