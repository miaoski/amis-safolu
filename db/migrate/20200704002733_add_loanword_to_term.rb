class AddLoanwordToTerm < ActiveRecord::Migration[6.0]
  def up
    add_column :raw_contents, :loanword, :boolean, default: false
    add_column :terms, :loanword, :boolean, default: false
  end

  def down
    remove_column :raw_contents, :loanword
    remove_column :terms, :loanword
  end
end
