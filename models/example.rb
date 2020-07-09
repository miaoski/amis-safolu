# == Schema Information
#
# Table name: examples
#
#  id             :integer          not null, primary key
#  description_id :integer
#  content        :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  linked_content :string(500)
#

class Example < ApplicationRecord
  belongs_to :description
end
