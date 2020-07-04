require 'pry'

require './models/application_record.rb'
require './models/definition'
require './models/description'
require './models/example'
require './models/synonym'

# 執行順序不可更換
Synonym.where(content: '').destroy_all

puts "clean Description"
Description.where(content: '').each do |description|
  if description.examples.blank? && description.synonyms.blank?
    puts description.id
    description.destroy
  end
end
Description.where(content: '。').each do |description|
  if description.examples.blank? && description.synonyms.blank?
    puts description.id
    description.destroy
  end
end

puts "clean Definition"
definition_ids = Definition.pluck(:id)
definition_ids_from_description = Description.distinct.pluck(:definition_id)
diff = definition_ids-definition_ids_from_description
puts diff.inspect
Definition.where(id: diff).destroy_all
