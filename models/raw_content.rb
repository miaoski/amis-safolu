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
#

class RawContent < ApplicationRecord
end
