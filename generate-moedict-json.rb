require 'pry'

require './models/application_record.rb'
require './models/stem'
require './models/term'
require './models/description'
require './models/example'

# index.json
def index_json
  terms_array = Term.pluck(:name)
  File.write("s/index.json", terms_array.to_json)
end

# stem-words.json
def stem_words_json
  stems_hash = {}
  Stem.includes(:terms).find_each do |stem|
    stems_hash[stem.name] = stem.terms.pluck(:name)
  end

  File.write("s/stem-words.json", stems_hash.to_json)
end

# revdict-amis-def.txt
def revdict_amis_def_txt
  File.open('s/revdict-amis-def.txt', 'w') do |file|
    Term.includes(:descriptions).find_each do |term|
      content = term.descriptions.pluck(:content).join
      file.puts "#{term.name}#{content}"
    end
  end
end

# revdict-amis-ex.txt
def revdict_amis_ex_txt
  File.open('s/revdict-amis-ex.txt', 'w') do |file|
    Term.includes(:descriptions).find_each do |term|
      content = Example.where(description_id: term.descriptions.pluck(:id)).pluck(:content).join
      file.puts "#{term.name}#{content}"
    end
  end
end

%w(index_json stem_words_json revdict_amis_def_txt revdict_amis_ex_txt).each do |name|
  eval(name)
end