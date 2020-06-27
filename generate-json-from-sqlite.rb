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
terms = JSON.parse(index_json)

# 跑一次大約要 40 分
terms.each do |name|
  hash = {t: name, h: []}

  Term.includes(:stem, definitions: {descriptions: [:examples, :synonyms]})
      .where("LOWER(name) = ?", name)
      .order(stem_id: :desc, repetition: :desc)
      .each_with_index do |term, i|
    hash[:h] += term.definitions.map do |definition|
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
    end

    if i.zero?
      hash[:stem] = term.stem.name            if term.stem.present?
      hash[:tag]  = "[疊 #{term.repetition}]" if term.repetition.to_i > 0
    end
  end

  File.write("s/#{name}.json", hash.to_json)
end
