# == Schema Information
#
# Table name: definitions
#
#  id         :integer          not null, primary key
#  term_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Definition < ApplicationRecord
  belongs_to :term
  has_many   :descriptions
end
