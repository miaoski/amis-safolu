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

# 跑一次大約要 220 秒
Term.includes(:stem, definitions: {descriptions: [:examples, :synonyms]})
    .find_each do |term|
  hash = {
    h: term.definitions.map do |definition|
      {
        d: definition.descriptions.map do |description|
          def_hash     = { f: description.content }
          def_hash[:e] = description.examples.map(&:content)
          def_hash[:s] = description.synonyms.alts.map(&:content)
          def_hash[:r] = description.synonyms.refs.map(&:content)

          def_hash.keys.each do |key|
            def_hash.delete(key) if def_hash[key].blank?
          end

          def_hash
        end
      }
    end,
    t: term.name
  }
  hash[:stem] = term.stem.name if term.stem.present?
  hash[:tag] = "[疊 #{term.repetition}]" if term.repetition.to_i > 0

  File.write("s/#{term.name}.json", hash.to_json)
end
