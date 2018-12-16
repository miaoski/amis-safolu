class AddRepetitionToTerms < ActiveRecord::Migration[5.0]
  def up
    add_column :terms, :repetition, :integer
  end

  def down
    remove_column :terms, :repetition, :integer
  end
end
