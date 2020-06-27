# == Schema Information
#
# Table name: descriptions
#
#  id            :integer          not null, primary key
#  definition_id :integer
#  content       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Description < ApplicationRecord
  belongs_to :definition
  has_many   :examples
  has_many   :synonyms
end
