class AddTermIdToDescription < ActiveRecord::Migration[6.0]
  def up
    add_column :descriptions, :term_id, :integer
    add_index  :descriptions, :term_id
  end

  def down
    remove_column :descriptions, :term_id
  end
end
