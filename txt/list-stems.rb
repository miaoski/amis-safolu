#
# 目的：抓出詞幹讓大家去編輯對應的漢字，提高漢阿搜尋精確度
# 運行方式：在終端機下執行命令
#   請先跑過 $ ruby txt/steam-mapping.rb
#   再跑 $ ruby txt/list-stems.rb
# 結果：執行命令後，會輸出結果在 tmp/list-amis-stems.csv
#   結果可以匯入 google sheets 方便協作

require "json"

raw_stems = File.read("tmp/amis-stem-words.json")
stems = JSON.parse(raw_stems)

raw_dict = File.read("txt/dict-amis.json")
dict = JSON.parse(raw_dict)
@words = {}
dict.each do |data|
  stem = data['title']
  @words[stem] = data['heteronyms'].first['definitions'].first['def']
end;1

File.open("tmp/list-amis-stems.csv", "w") do |file|
  file.puts "詞幹,解釋,對應漢字（二字內）"
  stems.keys.each do |stem|
    file.puts "#{stem},#{@words[stem]},"
  end
end
