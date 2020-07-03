# == Schema Information
#
# Table name: terms
#
#  id         :integer          not null, primary key
#  name       :string
#  stem_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  repetition :integer
#  lower_name :string
#  loanword   :boolean          default(FALSE)
#

class Term < ApplicationRecord
  belongs_to :stem
  has_one    :raw_content
  has_many   :definitions
  has_many   :descriptions

  validates_uniqueness_of :name

  before_save :set_lower_name

  private

  def set_lower_name
    self.lower_name = name.downcase
  end
end
