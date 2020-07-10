require 'pry'
require 'json'

require './models/application_record.rb'
require './models/raw_content'
require './models/stem'
require './models/term'
require './models/definition'
require './models/description'
require './models/example'
require './models/synonym'

index_json = File.read("s/index.json")
json = JSON.parse(index_json)
terms = json.map { |term| term.split("\ufffa").first }

total = terms.size

# 跑一次大約要 26 分
terms.each_with_index do |name, i|
  counter = i + 1
  print "\r** << #{format('%5d', counter)} / #{total}, #{format('%.2f', (counter.to_f / total * 100))}% >> **\tID: #{name}"

  hash = {t: name, h: []}

  Term.includes(:stem, definitions: {descriptions: [:examples, :synonyms]})
      .where(lower_name: name)
      .order(stem_id: :desc, repetition: :desc)
      .each_with_index do |term, i|
    hash[:h] += term.definitions.map do |definition|
      definition_hash = {
        d: definition.descriptions.map do |description|
          def_hash        = { f: description.content }
          def_hash[:e]    = description.examples.map(&:linked_content)
          def_hash[:s]    = description.synonyms.alts.map(&:linked_content)
          def_hash[:r]    = description.synonyms.refs.map(&:linked_content)

          def_hash.keys.each do |key|
            def_hash.delete(key) if def_hash[key].blank?
          end

          def_hash
        end
      }
      definition_hash[:name] = term.name if (term.name =~ /\p{Upper}/) != nil
      definition_hash
    end

    if i.zero?
      hash[:stem] = term.stem.name            if term.stem.present?
      hash[:tag]  = "[疊 #{term.repetition}]" if term.repetition.to_i > 0
    end
  end

  File.write("s/#{name}.json", hash.to_json)
end
