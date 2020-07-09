require 'pry'

require './models/application_record.rb'
require './models/stem'
require './models/term'
require './models/description'
require './models/example'
require './models/synonym'

# index.json
def index_json
  terms_hash = {}
  Term.find_each do |term|
    next if terms_hash[term.lower_name].present?
    terms_hash[term.lower_name] = term.descriptions.pluck(:content).join[0..10]
  end
  result = terms_hash.sort_by {|k,_| -k.length }.map{|term, description| "#{term}\ufffa#{description}" }
  File.write("s/index.json", result.to_json)
end

# stem-words.json
def stem_words_json
  stems_hash = {}
  Stem.includes(:terms).find_each do |stem|
    stems_hash[stem.name] = stem.terms.pluck(:lower_name).uniq
  end

  File.write("s/stem-words.json", stems_hash.to_json)
end

# revdict-amis-def.txt
# 萌典前端使用的標記
# \ufff9: 阿美語例句
# \ufffa: 英文例句
# \ufffb: 漢語例句
def revdict_amis_def_txt
  File.open('s/revdict-amis-def.txt', 'w') do |file|
    Term.includes(:descriptions).find_each do |term|
      content = term.descriptions.pluck(:content).join
      file.puts "\ufffa#{term.lower_name}\ufffb#{content}"
    end
  end
end

# revdict-amis-ex.txt
# 萌典前端使用的標記
# \ufff9: 阿美語例句
# \ufffa: 英文例句
# \ufffb: 漢語例句
def revdict_amis_ex_txt
  File.open('s/revdict-amis-ex.txt', 'w') do |file|
    Term.includes(:descriptions).find_each do |term|
      content = Example.where(description_id: term.descriptions.select(:id)).pluck(:content).join
      file.puts "\ufffa#{term.lower_name}\ufffb#{content}"
    end
  end
end

def copy_content_to_linked_content
  Example.find_in_batches do |examples|
    Example.transaction do
      examples.each do |example|
        example.update(linked_content: example.content)
      end
    end
  end

  Synonym.find_in_batches do |synonyms|
    Synonym.transaction do
      synonyms.each do |synonym|
        synonym.update(linked_content: synonym.content)
      end
    end
  end
end

# 跑一次大約要 300 秒
[
  'index_json',
  'stem_words_json',
  'revdict_amis_def_txt',
  'revdict_amis_ex_txt',
  'copy_content_to_linked_content'
].each do |method_name|
  eval(method_name)
end
