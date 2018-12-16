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
end
