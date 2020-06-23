# require 'pry'
# require 'ap'
require 'nokogiri'
html_doc = Nokogiri::HTML(File.read("tmp/dict-html/01-A.html"))

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
     text[0] == 'a'  ||
     text[0] == 'A'
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

require './models/application_record.rb'
require './models/raw_content'

h.each do |key, value|
  RawContent.create(key: key, value: value)
end
