# 目的：根據 txt 產生 stem to words 的對應表，格式為 JSON。會用在萌典搜尋列找出詞彙的排序。
# 運行方式：在終端機下執行命令 $ ruby txt/stem-mapping.rb
# 結果：執行命令後，會輸出結果在 tmp/amis-stem-words.json

require "json"

@stems = {}
Dir.glob("txt/*.txt").each do |filename|
  next if filename.include?("24-")

  lines = File.readlines(filename)
  terms = []
  empty_line = true
  lines.each do |line|
    line.strip!
    if empty_line
      terms << line
      empty_line = false
    end
    if line == ""
      empty_line = true
    end
  end

  terms.each do |term|
    word, stem = term.sub(")", "").split("(")
    if stem
      @stems[stem] ||= []
      @stems[stem] << word
    end
  end
end

@stems = @stems.inject({}) {|hash, stem| hash[stem[0]] = stem[1].sort; hash}

filepath = File.expand_path('../../tmp/amis-stem-words.json', __FILE__)
File.open(filepath, "w") do |file|
  file.puts JSON.pretty_generate(@stems)
end
