# == Schema Information
#
# Table name: synonyms
#
#  id            :integer          not null, primary key
#  definition_id :integer
#  content       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  term_type     :string(5)
#

class Synonym < ApplicationRecord
  belongs_to :definition
end
