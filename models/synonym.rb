# == Schema Information
#
# Table name: synonyms
#
#  id            :integer          not null, primary key
#  definition_id :integer
#  content       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Synonym < ApplicationRecord
  belongs_to :definition
end
