require 'pry'

require './models/application_record.rb'
require './models/stem'
require './models/term'
require './models/description'
require './models/example'

# index.json
def index_json
  terms_array = Term.pluck(:lower_name).uniq
  terms_array = terms_array.sort_by {|x| -x.length }
  File.write("s/index.json", terms_array.to_json)
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

# 跑一次大約要 300 秒
%w(index_json stem_words_json revdict_amis_def_txt revdict_amis_ex_txt).each do |method_name|
  eval(method_name)
end
