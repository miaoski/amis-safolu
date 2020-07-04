# == Schema Information
#
# Table name: raw_contents
#
#  id         :integer          not null, primary key
#  key        :string
#  value      :string
#  term_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  loanword   :boolean          default(FALSE)
#

class RawContent < ApplicationRecord
  belongs_to :term

  scope :amis,      -> { where(loanword: false) }
  scope :loanwords, -> { where(loanword: true) }
end
