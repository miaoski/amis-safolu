class AddRepetitionToTerms < ActiveRecord::Migration[6.0]
  def up
    add_column :terms, :repetition, :integer
  end

  def down
    remove_column :terms, :repetition, :integer
  end
end
