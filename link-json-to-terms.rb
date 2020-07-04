require 'pry'
require 'json'

require './models/application_record.rb'
require './models/term'
require './models/description'
require './models/example'
require './models/synonym'

# 總共大約要 49 分
index_json = File.read("s/index.json")
terms = JSON.parse(index_json)

terms_with_spaces    = []
terms_without_spaces = []
terms.each do |term|
  if term.include?(' ')
    terms_with_spaces    << term
  else
    terms_without_spaces << term
  end
end

total = terms_with_spaces.size
terms_with_spaces.each_with_index do |term, i|
  counter = i + 1
  print "\r** << #{format('%5d', counter)} / #{total}, #{format('%.2f', (counter.to_f / total * 100))}% >> **\tID: #{term}"

  current_term_ids = Term.where(lower_name: term).pluck(:id)
  current_description_ids = Description.where(term_id: current_term_ids).pluck(:id)

  ApplicationRecord.transaction do
    Description.where.not(id: current_description_ids)
               .where('content LIKE ?', "%#{term}%")
               .find_each do |description|
      new_content = description.content.gsub(/(#{term})/i, '`\1~')
      description.update(content: new_content)
    end

    Example.where.not(description_id: current_description_ids)
           .where('content LIKE ?', "%#{term}%")
           .find_each do |example|
      new_content = example.content.gsub(/(#{term})/i, '`\1~')
      example.update(content: new_content)
    end

    Synonym.where.not(description_id: current_description_ids)
           .where('content LIKE ?', "%#{term}%")
           .find_each do |synonym|
      new_content = synonym.content.gsub(/(#{term})/i, '`\1~')
      synonym.update(content: new_content)
    end
  end
end
puts "done terms_with_spaces"

total = terms_without_spaces.size
terms_without_spaces.each_with_index do |term, i|
  counter = i + 1
  print "\r** << #{format('%5d', counter)} / #{total}, #{format('%.2f', (counter.to_f / total * 100))}% >> **\tID: #{term}"

  current_term_ids = Term.where(lower_name: term).pluck(:id)
  current_description_ids = Description.where(term_id: current_term_ids).pluck(:id)

  ApplicationRecord.transaction do
    Description.where.not(id: current_description_ids)
               .where('content LIKE ?', "%#{term}%")
               .find_each do |description|
      new_content = description.content.split(/(`.*?~)/).map do |part|
        if part.include?("`")
          part
        else
          part.split(/( )/).map do |fragment|
            fragment.gsub(/(#{term})/i, '`\1~')
          end.join
        end
      end.join

      description.update(content: new_content)
    end

    Example.where.not(description_id: current_description_ids)
           .where('content LIKE ?', "%#{term}%")
           .find_each do |example|
      new_content = example.content.split(/(`.*?~)/).map do |part|
        if part.include?("`")
          part
        else
          part.split(/( )/).map do |fragment|
            fragment.gsub(/(#{term})/i, '`\1~')
          end.join
        end
      end.join

      example.update(content: new_content)
    end

    Synonym.where.not(description_id: current_description_ids)
           .where('content LIKE ?', "%#{term}%")
           .find_each do |synonym|
      new_content = synonym.content.split(/(`.*?~)/).map do |part|
        if part.include?("`")
          part
        else
          part.split(/( )/).map do |fragment|
            fragment.gsub(/(#{term})/i, '`\1~')
          end.join
        end
      end.join

      synonym.update(content: new_content)
    end
  end
end
