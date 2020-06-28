require 'json'

require './models/application_record.rb'
require './models/term'
require './models/description'
require './models/example'
require './models/synonym'

index_json = File.read("s/index.json")
terms = JSON.parse(index_json)
terms = terms.select {|t| t.length < 25} # 25 字以上先視為 bug

total = terms.size

# 跑一次大約要 42 分
terms.each_with_index do |term, i|
  counter = i + 1
  print "\r** << #{format('%5d', counter)} / #{total}, #{format('%.2f', (counter.to_f / total * 100))}% >> **\tID: #{term}"

  current_term_ids = Term.where(lower_name: term).pluck(:id)
  current_description_ids = Description.where(term_id: current_term_ids).pluck(:id)

  ApplicationRecord.transaction do
    Description.where.not(id: current_description_ids)
               .where('content LIKE ?', "%#{term}%")
               .find_each do |description|
      new_content = description.content.split(' ').map do |part|
        if part.include?("`") && part.include?("~")
          part
        else
          if part.include?(term)
            part.sub(term, "`#{term}~")
          else
            part
          end
        end
      end.join(' ')

      description.update(content: new_content)
    end

    Example.where.not(description_id: current_description_ids)
           .where('content LIKE ?', "%#{term}%")
           .find_each do |example|
      new_content = example.content.split(' ').map do |part|
        if part.include?("`") && part.include?("~")
          part
        else
          if part.include?(term)
            part.sub(term, "`#{term}~")
          else
            part
          end
        end
      end.join(' ')

      example.update(content: new_content)
    end

    Synonym.where.not(description_id: current_description_ids)
           .where('content LIKE ?', "%#{term}%")
           .find_each do |synonym|
      new_content = synonym.content.split(' ').map do |part|
        if part.include?("`") && part.include?("~")
          part
        else
          if part.include?(term)
            part.sub(term, "`#{term}~")
          else
            part
          end
        end
      end.join(' ')

      synonym.update(content: new_content)
    end
  end
end
