# == Schema Information
#
# Table name: stems
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Stem < ApplicationRecord
  has_many :terms

  validates_uniqueness_of :name
end
