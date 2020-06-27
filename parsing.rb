require 'pry'
require 'ap'
require 'nokogiri'

require './models/application_record.rb'
require './models/raw_content'

FILE_LIST = [
  '01-A.html',
  '02-C.html',
  '03-D.html',
  '04-E.html',
  '05-F.html',
  '06-H.html',
  '07-I.html',
  '08-K.html',
  '09-L.html',
  '10-M.html',
  '11-Map-1.html',
  '12-M-2(mi).html',
  '13-M-3(mil-mip).html',
  '14-M-4.html',
  '15-N.html',
  '16-Ng.html',
  '17-O.html',
  '18-P.html',
  '19-R.html',
  '20-S.html',
  '21-T.html',
  '22-WXY.html',
  '23-阿美語輔音.html',
  '24-阿美族常用借詞.html',
]

def parsing_by_file(name:)
  html_doc = Nokogiri::HTML(File.read("tmp/dict-html/#{name}"))

  h={}
  current_key=''
  html_doc.css('multicol p').each do |p|
    is_content = false

    text   = p.text.gsub(/\n|\t| /, ' ')
                   .gsub(/ +/, ' ')
                   .sub(/\A /, '')
    styles = p['style'].split(';').inject({}){|h,s| k,v=s.split(': '); h[k]=v; h}
    styles.each do |property, value|
      if ['text-indent', 'margin-left'].include?(property)
        value = value.to_f
        is_content = true if !is_content && value != 0.0
      end
    end

    if text[0] == '\'' ||
       text[0] == '’'  ||
       text[0] == '^'  ||
       text[0] == '-'  ||
       text[0] == 'A'  || text[0] == 'a' ||
       text[0] == 'C'  || text[0] == 'c' ||
       text[0] == 'D'  || text[0] == 'd' ||
       text[0] == 'E'  || text[0] == 'e' ||
       text[0] == 'F'  || text[0] == 'f' ||
       text[0] == 'H'  || text[0] == 'h' ||
       text[0] == 'I'  || text[0] == 'i' ||
       text[0] == 'K'  || text[0] == 'k' ||
       text[0] == 'L'  || text[0] == 'l' ||
       text[0] == 'M'  || text[0] == 'm' ||
       text[0] == 'N'  || text[0] == 'n' ||
       text[0] == 'O'  || text[0] == 'o' ||
       text[0] == 'P'  || text[0] == 'p' ||
       text[0] == 'R'  || text[0] == 'r' ||
       text[0] == 'S'  || text[0] == 's' ||
       text[0] == 'T'  || text[0] == 't' ||
       text[0] == 'U'  || text[0] == 'u' ||
       text[0] == 'W'  || text[0] == 'w' ||
       text[0] == 'X'  || text[0] == 'x' ||
       text[0] == 'Y'  || text[0] == 'y'
      is_content = false unless is_content
    else
      is_content = true
    end

    if is_content
      h[current_key] << text if !text.nil? && text != ''
    else
      current_key = text
      h[current_key] ||= []
    end
  end

  h.each do |key, value|
    key = key.gsub(/’/, "'")
    value = value.to_s.gsub(/’/, "'")
    RawContent.create(key: key, value: value)
  end
end

# 跑一次大約要 150 秒
FILE_LIST.each do |filename|
  parsing_by_file(name: filename)
end
