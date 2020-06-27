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
#

class Term < ApplicationRecord
  belongs_to :stem
  has_one    :raw_content
  has_many   :definitions
  has_many   :descriptions

  validates_uniqueness_of :name
end
