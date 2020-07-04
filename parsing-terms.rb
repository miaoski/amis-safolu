require './models/application_record.rb'
require './models/raw_content'
require './models/term'
require './models/stem'

# 跑一次大約要 16 分鐘
total = RawContent.count
counter = 0

RawContent.find_each do |raw|
  counter += 1
  print "\r** << #{format('%5d', counter)} / #{total}, #{format('%.2f', (counter.to_f / total * 100))}% >> **\tID: #{raw.id}"

  key = raw.key
  key.sub!(/）|\)/, '')
  _term, _stem = key.split(/（|\(/)
  _term.strip!
  _stem&.strip!

  stem = Stem.find_or_create_by(name: _stem) if _stem.present?
  if stem.present?
    term = Term.find_or_create_by(name: _term)
    term.update(stem_id: stem.id)
  else
    term = Term.find_or_create_by(name: _term)
  end

  raw.update(term_id: term.id)
end
