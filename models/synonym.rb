# == Schema Information
#
# Table name: synonyms
#
#  id             :integer          not null, primary key
#  description_id :integer
#  content        :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  term_type      :string(5)
#  linked_content :string
#

class Synonym < ApplicationRecord
  belongs_to :description

  scope :alts, -> { where(term_type: '同') }
  scope :refs, -> { where(term_type: '參見') }
end
