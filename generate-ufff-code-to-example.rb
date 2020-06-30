require './models/application_record.rb'
require './models/example'

# 跑一次大約要 100 秒
Example.find_each do |example|
  amis = []
  content_array = example.content.split(/(?<=[?.!])/)

  content_array.each do |partial|
    if (partial =~ /\p{Han}/).nil?
      amis << partial.strip
    else
      break
    end
  end

  ch_array = content_array - amis
  ch_array.each(&:strip!)

  example.update(content: "\ufff9#{amis.join}\ufffa\ufffb#{ch_array.join}")
end
