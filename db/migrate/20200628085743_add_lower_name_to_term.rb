class AddLowerNameToTerm < ActiveRecord::Migration[6.0]
  def up
    add_column :terms, :lower_name, :string
    add_index  :terms, :lower_name
  end

  def down
    remove_column :terms, :lower_name
  end
end
