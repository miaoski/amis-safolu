# 目的：將 Google sheet 的漢字阿美語詞幹對應，轉成 json，提升 amis.moedict.tw 上漢阿搜尋的精確度
# 運行方式：
#   請先到 https://goo.gl/LHnG1B，匯出成 csv
#   將檔案更名為 amis-ch-mapping-sheet.csv，並放到專案的 tmp/
#   在終端機下執行命令 $ ruby txt/ch-amis.rb
# 結果：執行命令後，會輸出結果在 tmp/amis-ch-mapping.json

require 'csv'
require 'json'

csv = CSV.read('tmp/amis-ch-mapping-sheet.csv')
csv.delete_at 0

@mapping = {}
csv.each do |data|
  stem = data[0]
  data[2..4].each do |chinese|
    next if chinese.nil?
    next if chinese == ''
    puts "重複： #{chinese}, 位置： #{data}" unless @mapping[chinese].nil?
    @mapping[chinese] ||= stem
  end
end

filepath = File.expand_path('../../tmp/amis-ch-mapping.json', __FILE__)
File.open(filepath, "w") do |file|
  file.puts JSON.pretty_generate(@mapping)
end
