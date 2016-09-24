# 目的：檢查 txt 是否有標注詞幹 stem，但卻沒有這個詞的定義
# 運行方式：在終端機下執行命令 $ ruby txt/stem-checker.rb
# 結果：執行命令後，會輸出結果在 tmp/缺少定義的詞幹.txt

require "pry"
require "json"

@words = []
@stems = []
@mapping = {}

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

  words = []
  stems = []
  terms.each do |term|
    word, stem = term.sub(")", "").split("(")
    words << word
    if stem
      stems << stem
      @mapping[stem] ||= []
      @mapping[stem] << term
    end
  end

  @words += words
  @stems += stems.uniq
end

missed = []
@stems.each do |stem|
  unless @words.include? stem
    missed << stem
  end
end
missed.uniq!

File.open("tmp/缺少定義的詞幹.csv", "w") do |file|
  file.puts "詞幹,字"
  missed.each do |term|
    file.puts "#{term},#{@mapping[term].join(',')}"
  end
end
