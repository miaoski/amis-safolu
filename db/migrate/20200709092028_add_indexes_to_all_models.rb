class AddIndexesToAllModels < ActiveRecord::Migration[6.0]
  def up
    add_index :definitions,  :term_id
    add_index :descriptions, :definition_id
    add_index :examples,     :description_id
    add_index :raw_contents, :key
    add_index :raw_contents, :loanword
    add_index :stems,        :name
    add_index :synonyms,     :description_id
    add_index :terms,        :name
    add_index :terms,        :loanword
  end

  def down
    remove_index :definitions,  :term_id
    remove_index :descriptions, :definition_id
    remove_index :examples,     :description_id
    remove_index :raw_contents, :key
    remove_index :raw_contents, :loanword
    remove_index :stems,        :name
    remove_index :synonyms,     :description_id
    remove_index :terms,        :name
    remove_index :terms,        :loanword
  end
end
